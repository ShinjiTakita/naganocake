class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def confirm
    @order = Order.new(order_params)
# new 画面から渡ってきたデータを @order に入れます
    if params[:order][:select_address] == "1"
    @order.postal_code = current_customer.postal_code
    @order.name = current_customer.last_name + current_customer.first_name # @order の各カラムに必要なものを入れます
    @order.address = current_customer.address
    elsif params[:order][:select_address] == "2"
      @order.name = Address.find(params[:order][:address_id]).name
      @order.address = Address.find(params[:order][:address_id]).address
      @order.postal_code = Address.find(params[:order][:address_id]).postal_code
    elsif params[:order][:select_address] == "3"
    address_new = current_customer.addresses.new
    address_new.postal_code = params[:order][:postal_code]
    address_new.address = params[:order][:address]
    address_new.name = params[:order][:name]
    if address_new.save
      @order.postal_code = address_new.postal_code
      @order.address = address_new.address
      @order.name = address_new.name
    end
    else
    redirect_to new_order_path # ありえないですが、万が一当てはまらないデータが渡って
    end
    @cart_items = current_customer.cart_items.all # カートアイテムの情報をユーザーに確認してもらうために使用します
    @billing = @cart_items.inject(0) { |sum, item| sum + item.total_price }
  end

  def create
    @order = current_customer.orders.new(order_params)
    @order.status = 1
  # 渡ってきた値を @order に入れます
    if @order.save
      current_customer.cart_items.each do |cart|
  # 取り出したカートアイテムの数繰り返します
  # order_detail にも一緒にデータを保存する必要があるのでここで保存します
        order_detail = OrderDetail.new
        order_detail.item_id = cart.item_id
        order_detail.order_id = @order.id
        order_detail.amount = cart.amount
  # 購入が完了したらカート情報は削除するのでこちらに保存します
        order_detail.price = cart.item.price
  # カート情報を削除するので item との紐付けが切れる前に保存します
        order_detail.making_status = 1
        order_detail.save
      end
      current_customer.cart_items.destroy_all
      redirect_to orders_purchase_completed_path
  # ユーザーに関連するカートのデータ(購入したデータ)をすべて削除します(カートを空にする)
    end
  end

  def purchase_completed_path
  end

  def index
    @orders = current_customer.orders.page(params[:page]).per(4)
  end

  def show
    @order = Order.find(params[:id])
  end

  private
  def order_params
    params.require(:order).permit(:postal_code, :address, :name, :postage, :billing, :payment_method, :status)
  end

  def address_params
  params.require(:address).permit(:name, :address, :postal_code)
  end

end
