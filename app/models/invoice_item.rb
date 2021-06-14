# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum status: { pending: 0, packaged: 1, shipped: 2 }

  def self.merch_not_shipped(merch_id)
    select('invoice_items.*, merchants.id as merch_id, items.name as name, invoices.id as invoice_id')
      .joins(item: :merchant)
      .joins(invoice: :transactions)
      .order(created_at: :asc)
      .where.not(status: 2)
      .where('merchants.id = ?', merch_id)
      .where.not('transactions.result = ?', 1)
  end

  def applied_discount
    item.merchant.bulk_discounts
    .where("quantity_threshold <= ?", self.quantity)
    .first
  end

  def apply_discount
    if !self.applied_discount.nil?
      discount = ( 1 - (self.applied_discount.discount_percent.to_d / 100))
      self.unit_price = (self.unit_price * discount)
      self
    else
      self
    end
  end
end