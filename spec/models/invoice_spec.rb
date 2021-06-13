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
        
      end
    end

    describe 'invoice_items_formatted' do
      it 'returns invoice items and item names for given invoice' do
        id = Invoice.first.id
        
        expect(Invoice.invoice_items_formatted(id)).to eq([InvoiceItem.find(1), InvoiceItem.find(2), InvoiceItem.find(3), InvoiceItem.find(4)])
        expect(Invoice.invoice_items_formatted(id).first.name).to eq("Rustic Silk Car")
        expect(Invoice.invoice_items_formatted(id).first.merchant_id).to eq(3)
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
