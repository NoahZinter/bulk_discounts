# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  describe 'class methods' do
    describe '#top_5_customers_by_transactions' do
      it 'gives the top 5 customers by transactions' do
        data = Customer.top_5_customers_by_transactions

        expect(data.map(&:first_name)).to match_array %w[An Dean Lemuel Lindsey Vivan]
        expect(data.map(&:transaction_count)).to match_array [2, 3, 3, 3, 4]
      end
    end

    describe '#top_five' do
      it 'should return top 5 customers for the given merchant by transaction count' do
        merchant = Merchant.find(3)
        customer_7 = Customer.find(7)
        customer_6 = Customer.find(6)
        customer_8 = Customer.find(8)
        customer_9 = Customer.find(9)

        expect(Customer.top_five(merchant.id)).to eq([customer_7, customer_6, customer_8, customer_9])
      end
    end
  end
end
