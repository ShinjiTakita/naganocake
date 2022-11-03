class Public::HomesController < ApplicationController
  def top
     @items = Item.all.page(params[:page]).per(4)
  end

  def about
  end
end
