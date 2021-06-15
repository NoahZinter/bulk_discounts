# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  describe 'class methods' do
    describe 'merch not shipped' do
      it 'displays unshipped invoice items' do
        @merchant = Merchant.find(1)
        expected = [
          InvoiceItem.find(2), InvoiceItem.find(8), InvoiceItem.find(29), 
          InvoiceItem.find(45), InvoiceItem.find(49), InvoiceItem.find(50), InvoiceItem.find(58), InvoiceItem.find(59), InvoiceItem.find(83), 
          InvoiceItem.find(90), InvoiceItem.find(92), InvoiceItem.find(94), InvoiceItem.find(96), InvoiceItem.find(97),
          InvoiceItem.find(105), InvoiceItem.find(106), InvoiceItem.find(113), InvoiceItem.find(114), InvoiceItem.find(121),
          InvoiceItem.find(122), InvoiceItem.find(137), InvoiceItem.find(154), InvoiceItem.find(171), InvoiceItem.find(176),
          InvoiceItem.find(182), InvoiceItem.find(194)
          ]

          expect(InvoiceItem.merch_not_shipped(@merchant.id)).to eq(expected)
          expect(expected.first.status).not_to eq("shipped")
      end
    end
  end

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

    describe 'apply discount' do
      it 'changes unit price in accordance with discount' do
        expect(@invoice_item_1.unit_price.to_f).to eq(145)

        @invoice_item_1.apply_discount

        expect(@invoice_item_1.unit_price.to_f).to eq(36.25)
      end

      it 'does not misapply discounts' do
        static_ii = InvoiceItem.find(60)

        expect(static_ii.item.merchant.id).to eq(5)
        expect(Merchant.find(5).bulk_discounts).to eq([])
        expect(static_ii.unit_price.to_f).to eq(192.0)

        static_ii.apply_discount

        expect(static_ii.unit_price.to_f).to eq(192.0)
      end
    end
  end
end
