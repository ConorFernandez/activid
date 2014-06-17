class OrdersController < ApplicationController
  def show
    @order = find_order_by_cookie
    @order ||= Order.create! status: Order::Status::DRAFT, video_length: VideoLength.enabled.first

    cookies[:order_secure_token] = @order.secure_token
  end

  def update
    @order = find_order_by_cookie
    redirect_to(orders_path) and return if @order.blank?
    @order.update_attributes(order_params)
    if @order.errors.blank?
      render json: {}
    else
      render json: { errors: @order.errors }, status: 400
    end
  end

  def checkout
    @order = find_order_by_cookie
  end

  def submit_payment
    @order = find_order_by_cookie
    redirect_to(success_orders_path) and return if @order.paid?
    unless @order.stripe_customer_id
      stripe_token = params[:stripe_token]
      customer = Stripe::Customer.create(card: stripe_token,
                              email: @order.cardholder_email,
                              description: <<-EOS
                              Name: #{@order.cardholder_name}.
                              Uploaded files: s3://activid/#{@order.secure_token}/
                              Minutes: #{@order.video_length}
                              EOS
      )
      @order.update_attributes(stripe_customer_id: customer.id)
    end

    # NOTE: remove block on 6/14/2014 if this is still the desired behavior.
    # unless @order.order_cost.fractional == 0
    #   Stripe::Charge.create(
    #       amount: @order.order_cost.fractional,
    #       currency: 'usd',
    #       customer: @order.stripe_customer_id
    #   )
    # end
    @order.update_attributes(status: Order::Status::PAID)
    cookies.delete :order_secure_token

    AdminMailer.new_order(@order).deliver
    UserMailer.new_order(@order).deliver

    redirect_to success_orders_path

  rescue Stripe::StripeError => se
    flash[:stripe_error] = se.message
    redirect_to checkout_orders_path
  end


  def attach_coupon
    coupon = Coupon.enabled.where(code: coupon_params[:code]).first
    if coupon && coupon.is_usable?
      order = find_order_by_cookie
      order.coupon = coupon
      order.save!
      render_coupon(coupon, order)
    else
      if coupon.blank?
        render_coupon_error 'Coupon code not found'
      elsif !coupon.is_usable?
        render_coupon_error 'Coupon code is no longer available'
      end
    end
  end

  protected

  def order_params
    params.require(:order).permit(:project_name, :video_length_id, :instructions, :preparing_for_payment,
                                  :cardholder_name, :cardholder_address, :cardholder_city, :cardholder_state,
                                  :cardholder_zipcode, :cardholder_email, :cardholder_phone_number,
                                  order_files_attributes: [:original_filename, :uploaded_filename]
    )
  end

  def coupon_params
    params.require(:coupon).permit(:code)
  end

  def render_coupon_error(error)
    render json: {
        error: error
    }, status: 400
  end

  def render_coupon(coupon, order)
    render json: {
        name: coupon.name,
        discount: coupon.discount.to_f,
        new_order_cost: order.order_cost.to_f
    }
  end
end
