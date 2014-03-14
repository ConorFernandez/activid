module OrdersHelper
  def current_order_token
    cookies[:order_secure_token]
  end
end
