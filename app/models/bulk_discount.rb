class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  validates :quantity_threshold, :discount_percent, presence: true, numericality: true

  def self.default_scope
    order(discount_percent: :desc, quantity_threshold: :asc)
  end
end
