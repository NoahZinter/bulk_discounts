# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  def self.top_5_customers_by_transactions
    select('customers.*, count(transactions.id) as transaction_count, transactions.result')
      .joins(invoices: :transactions)
      .where('transactions.result': 1)
      .group('customers.id', 'transactions.result')
      .order(transaction_count: :desc)
      .limit(5)
  end

  def self.top_five(merch_id)
    select('customers.*, merchant_id, count(transactions) as trans_count, transactions.result')
      .joins(invoices: [{ invoice_items: { item: :merchant } }, :transactions])
      .group(:merchant_id, :id, 'transactions.result')
      .order(trans_count: :desc)
      .where('merchant_id = ?', merch_id)
      .where('transactions.result = 2')
      .limit(5)
  end
end
