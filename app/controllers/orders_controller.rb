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

    Stripe::Charge.create(
        amount: @order.order_cost.fractional,
        currency: 'usd',
        customer: @order.stripe_customer_id
    )
    @order.update_attributes(status: Order::Status::PAID)
    redirect_to success_orders_path

  rescue Stripe::StripeError => se
    flash[:stripe_error] = se.message
    redirect_to checkout_orders_path
  end

  protected

  def order_params
    params.require(:order).permit(:project_name, :video_length_id, :instructions, :preparing_for_payment,
                                  :cardholder_name, :cardholder_address, :cardholder_city, :cardholder_state,
                                  :cardholder_zipcode, :cardholder_email, :cardholder_phone_number,
                                  order_files_attributes: [:original_filename, :uploaded_filename]
    )
  end

  def find_order_by_cookie
    secure_token = cookies[:order_secure_token]
    return nil if secure_token.blank?
    Order.where(secure_token: secure_token).first
  end
end
