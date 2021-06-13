# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  # describe 'class methods' do
    
  # end

  describe 'instance methods' do
    before(:each) do
      @invoice_item_1 = InvoiceItem.find(1)
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
      @discount_9 = @merchant_3.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 30)
      @discount_10 = @merchant_3.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
      @discount_11 = @merchant_3.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
    end
    describe 'applied discount' do
      it "returns highest applicable discount" do
        expect(@invoice_item_1.applied_discount).to eq(@discount_10)
      end
    end
  end
end
