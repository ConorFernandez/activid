module OrdersHelper
  def current_order_token
    cookies[:order_secure_token]
  end

  def order_files_to_json(order_files)
    order_files.map do |of|
      { original_filename: File.basename(of.original_filename) }
    end.to_json
  end
end
