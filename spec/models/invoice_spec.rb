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
      @invoice_1 = Invoice.find(1)
      @invoice_2 = Invoice.find(2)
      @invoice_3 = Invoice.find(3)
      @merchant_1 = Merchant.find(1)
      @merchant_2 = Merchant.find(2)
      @merchant_3 = Merchant.find(3)
      BulkDiscount.destroy_all
      @discount_1 = @merchant_3.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
      @discount_2 = @merchant_3.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
      @discount_3 = @merchant_3.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
      @discount_4 = @merchant_1.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 15)
      @discount_5 = @merchant_2.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 15)
      @discount_6 = @merchant_2.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 20)
      @discount_7 = @merchant_2.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 25)
      @discount_8 = @merchant_2.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 20)
      @discount_9 = @merchant_3.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 20)
      @discount_10 = @merchant_3.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
      @discount_11 = @merchant_3.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
      
    end
    describe 'revenue' do
      xit 'shows the revenue for an invoice' do
        expect(@invoice.revenue.to_f / 100).to eq(626.91)
      end
    end
    describe 'applied_discounts' do
      it 'shows applied discounts' do
        expect(@invoice.applied_discounts).to eq([@discount_3, @discount_2, @discount_1])
      end
    end
  end
end
