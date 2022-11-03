class Admin::OrderDetailsController < ApplicationController
  def update
    @order_detail = OrderDetail.find(params[:id])
    @order = @order_detail.order
    @order_details = @order.order_details

    # is_updated = true
    if @order_detail.update(order_detail_params)
      if @order_detail.making_status == "in_production"
        @order.update(status: "in_production")
      end
      if @order_details.count == @order_details.where(making_status: "completion_of_production").count
          @order.update(status: "preparing_for_ship")
      end
    end
    redirect_to admin_order_path(@order_detail.order)
  end

  private
    def order_detail_params
      params.require(:order_detail).permit(:making_status)
    end
end
