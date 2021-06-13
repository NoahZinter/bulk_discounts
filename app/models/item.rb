# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  enum status: { disabled: 0, enabled: 1 }

  validates :name, :description, :unit_price, presence: true

  scope :invoice_items_formatted, lambda { |merchant_id|
                       select('merchants.id, items.*, invoice_items.quantity, invoice_items.status')
                         .joins(invoice_items: :invoice)
                         .where('merchants.id = ?', merchant_id)
                     }

  def top_day
    date_string = invoices.joins(:invoice_items, :transactions)
                          .where('transactions.result = 2')
                          .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
                          .group(:id)
                          .order(revenue: :desc, created_at: :desc)
                          .limit(1)
                          .first
                          .created_at
    date_string.to_date
  end
end
