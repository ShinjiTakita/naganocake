class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item

  enum making_status: { cannot_be_produced: 1, waiting_for_production: 2, in_production: 3, completion_of_production: 4 }


end
