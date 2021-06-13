require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant)}
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity_threshold) }
    it { should validate_presence_of(:discount_percent) }
    it { should validate_numericality_of(:quantity_threshold) }
    it { should validate_numericality_of(:discount_percent) }
  end

  describe 'class methods' do
    before(:each) do
      @invoice = Invoice.find(1)
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
      @discount_9 = @merchant_3.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 30)
      @discount_10 = @merchant_3.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
      @discount_11 = @merchant_3.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
    end
    describe 'default scope' do
      it 'orders by discount percent desc and quantity threshold asc' do
        expect(@merchant_3.bulk_discounts).to eq([@discount_10, @discount_3, @discount_9, @discount_2, @discount_1, @discount_11])
      end
    end

    describe 'applied discount' do
      it 'returns applicable discounts' do
        
      end
    end
  end
end
