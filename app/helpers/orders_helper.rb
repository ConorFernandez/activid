module OrdersHelper
  def current_order_token
    cookies[:order_secure_token]
  end

  def order_files_to_json(order_files)
    order_files.map do |of|
      { original_filename: File.basename(of.original_filename) }
    end.to_json
  end

  def random_pic
    imgs = [
      '//i.vimeocdn.com/video/468234911_295x166.jpg',
      'http://i.vimeocdn.com/video/468139144_295x166.jpg',
      'http://i.vimeocdn.com/video/468094847_295x166.jpg',
      'http://i.vimeocdn.com/video/449882718_295x166.jpg'
    ]
    image_tag imgs.sample
  end
end
