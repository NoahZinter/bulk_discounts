# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  describe 'class methods' do
    describe 'incomplete_invoices' do
      it 'gives invoices that are incomplete' do
        data = Invoice.incomplete_invoices
        expect(data.count).to eq 15
        expect(data.first.status).to eq('in progress')
        expect(data.last.status).to eq('in progress')
      end
    end

    describe 'merchant_invoices' do
      it 'selects invoices for a merchant' do
        merchant = Merchant.find(2)
        expected = [
          Invoice.find(4),
          Invoice.find(5),
          Invoice.find(7),
          Invoice.find(8),
          Invoice.find(11),
          Invoice.find(12),
          Invoice.find(16),
          Invoice.find(17),
          Invoice.find(19),
          Invoice.find(20),
          Invoice.find(21),
          Invoice.find(22),
          Invoice.find(23),
          Invoice.find(24),
          Invoice.find(25),
          Invoice.find(26),
          Invoice.find(27),
          Invoice.find(28),
          Invoice.find(30),
          Invoice.find(31),
          Invoice.find(32),
          Invoice.find(33),
          Invoice.find(34),
          Invoice.find(35),
          Invoice.find(36),
          Invoice.find(37),
          Invoice.find(38),
          Invoice.find(39),
          Invoice.find(41),
          Invoice.find(42),
          Invoice.find(43),
          Invoice.find(44),
          Invoice.find(48),
          Invoice.find(50)
        ]
        expect(Invoice.merchant_invoices(merchant.id)).to eq(expected)
      end
    end

    describe 'invoice_items_formatted' do
      it 'returns invoice items and item names for given invoice' do
        invoice = Invoice.first
        
        expect(invoice.invoice_items_formatted).to eq([InvoiceItem.find(1), InvoiceItem.find(2), InvoiceItem.find(3), InvoiceItem.find(4)])
        expect(invoice.invoice_items_formatted.first.name).to eq("Rustic Silk Car")
        expect(invoice.invoice_items_formatted.first.merchant_id).to eq(3)
      end
    end
  end

  describe 'instance methods' do
    describe 'revenue' do
      it 'shows the revenue for an invoice' do
        invoice = Invoice.first
        expect(invoice.revenue.to_f / 100).to eq(626.91)
      end
    end
  end
end
