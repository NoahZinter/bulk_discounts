# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items
  has_many :bulk_discounts
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  def self.top_5_merchants
    joins(items: :invoice_items)
      .joins('JOIN transactions ON invoice_items.invoice_id = transactions.invoice_id')
      .select('merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
      .where('transactions.result': 2)
      .group('merchants.id')
      .order('revenue desc')
      .limit(5)
    # SELECT m.id, m.name, sum(ii.quantity * ii.unit_price) as revenue
    # FROM merchants as m
    # JOIN items as i ON m.id = i.merchant_id
    # JOIN invoice_items as ii ON i.id = ii.item_id
    # JOIN transactions as t ON ii.invoice_id = t.invoice_id
    # WHERE t.result = 2
    # GROUP BY m.id
    # ORDER BY revenue DESC
    # LIMIT 5;
  end

  def top_day
    Invoice.joins(items: :invoice_items)
           .joins('JOIN merchants ON items.merchant_id = merchants.id')
           .joins('JOIN transactions ON invoice_items.invoice_id = transactions.invoice_id')
           .select('invoices.created_at')
           .where('transactions.result': 2)
           .where('merchants.id': id)
           .group('invoices.id, invoices.created_at')
           .order('sum(invoice_items.quantity * invoice_items.unit_price) desc')
           .limit(1)
    # SELECT i.*, sum(ii.quantity * ii.unit_price) as revenue
    # FROM invoices as i
    # JOIN invoice_items as ii ON i.id = ii.invoice_id
    # JOIN items as it ON ii.item_id = it.id
    # JOIN transactions as t ON i.id = t.invoice_id
    # JOIN merchants as m ON it.merchant_id = m.id
    # WHERE t.result = 2 AND m.id = 14
    # GROUP BY i.id, i.created_at
    # ORDER BY revenue DESC
    # LIMIT 1;
  end

  def top_five_items
    Item.joins(invoices: :transactions)
        .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
        .where(merchant_id: id)
        .where('transactions.result = 2')
        .group(:id)
        .order(revenue: :desc)
        .limit(5)
  end
end
