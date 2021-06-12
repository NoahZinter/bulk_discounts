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
    describe 'default scope' do
      it 'orders by discount percent desc and quantity threshold asc' do
        @merchant = Merchant.find(1)
        BulkDiscount.destroy_all
        @discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 20)
        @discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 25)
        @discount_3 = @merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
        @discount_4 = @merchant.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 30)
        @discount_5 = @merchant.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)

        expect(@merchant.bulk_discounts).to eq([@discount_3, @discount_4, @discount_2, @discount_1, @discount_5])
      end
    end
  end
end
