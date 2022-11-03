class Item < ApplicationRecord
  has_one_attached :image

  belongs_to :genre
  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy

  def status
    if is_active == true
      "販売中"
    else
      "販売停止中"
    end
  end

  def add_tax_price
    (self.price*1.10).round
  end

  def get_image
    if image.attached?
      image
    else
      'no_image.jpg'
    end
  end
end
