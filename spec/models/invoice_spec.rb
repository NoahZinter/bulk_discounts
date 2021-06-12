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
  end
  describe 'instance methods' do
    before(:each) do
      BulkDiscount.destroy_all
      @merchant_1 = Merchant.find(1)
      @merchant_3 = Merchant.find(3)
      @discount_1 = @merchant_3.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
      @discount_2 = @merchant_3.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
      @discount_3 = @merchant_3.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
      @discount_4 = @merchant_1.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 15)
    end
    describe 'revenue' do
      it 'shows the revenue for an invoice' do
        invoice = Invoice.first

        expect(invoice.revenue.to_f / 100).to eq(626.91)
      end
    end
  end
end
