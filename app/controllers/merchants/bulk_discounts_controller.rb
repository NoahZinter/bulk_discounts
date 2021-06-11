module Merchants
  class BulkDiscountsController < ApplicationController
    def index
      @merchant = Merchant.find(params[:id])
      @bulk_discounts = @merchant.bulk_discounts
      @holidays = Holidays.next_three('US')
    end

    def show
      @merchant = Merchant.find(params[:id])
      @discount = BulkDiscount.find(params[:discount_id])
    end
  end
end