class OrdersController < ApplicationController
  def show
    @order = find_order_by_cookie
    @order ||= Order.create! status: Order::Status::DRAFT

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

  protected

  def order_params
    params.require(:order).permit(:project_name, :video_length, :instructions, :preparing_for_payment,
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
