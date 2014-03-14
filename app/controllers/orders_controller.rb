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
    head 200
  end

  protected

  def order_params
    params.require(:order).permit(:project_name, :video_length, :instructions,
                                  order_files_attributes: [:original_filename, :uploaded_filename]
    )
  end

  def find_order_by_cookie
    secure_token = cookies[:order_secure_token]
    return nil if secure_token.blank?
    Order.where(secure_token: secure_token).first
  end
end
