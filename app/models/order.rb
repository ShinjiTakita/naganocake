class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details

  enum payment_method: { credit_card: 1, transfer: 2 }
  enum status: { waiting_for_payment: 1, payment_confirmation: 2, in_production: 3, preparing_for_ship: 4, shipped: 5 }

  def postage
    800
  end
end
