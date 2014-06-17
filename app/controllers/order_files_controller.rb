class OrderFilesController < ApplicationController
  respond_to :json

  def create
    @order = find_order_by_cookie
    order_file = @order.order_files.create! order_file_params
    render json: order_file
  end

  def destroy
    @order = find_order_by_cookie
    @order.order_files.find(params[:id]).destroy
    head :ok
  end

  protected

  def order_file_params
    params.require(:order_file).permit(:original_filename, :uploaded_filename)
  end
end
