class OrdersController < ApplicationController
  def show
    @order = find_order_by_cookie
    @order ||= Order.create! status: Order::Status::DRAFT

    cookies[:order_secure_token] = @order.secure_token
    head 200
  end

  protected

  def find_order_by_cookie
    secure_token = cookies[:order_secure_token]
    return nil if secure_token.blank?
    Order.where(secure_token: secure_token).first
  end
end
