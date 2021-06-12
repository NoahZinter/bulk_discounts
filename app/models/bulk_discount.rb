class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  validates :quantity_threshold, :discount_percent, presence: true, numericality: true
end
