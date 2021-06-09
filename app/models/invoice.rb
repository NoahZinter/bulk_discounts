class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: {'in progress': 0, cancelled: 1, completed: 2}

  def self.incomplete_invoices
    joins(:invoice_items)
      .where('invoice_items.status != 2')
      .where(status: 0)
      .order(:created_at)
      .distinct
  end

  def revenue
    invoice_items.sum('quantity * unit_price') /100
  end
  def self.merchant_invoices(merchant_id)
    select('DISTINCT invoices.*')
    .joins(invoice_items: :item)
    .where('items.merchant_id = ?', merchant_id)
  end

  def self.from_merch(invoice_id)
    find(invoice_id)
    .invoice_items
    .select('invoice_items.* ,items.name, items.merchant_id')
    .joins(:item)
  end
end
