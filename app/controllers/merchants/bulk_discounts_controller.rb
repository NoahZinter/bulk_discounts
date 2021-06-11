module Merchants
  class BulkDiscountsController < ApplicationController
    def index
      @merchant = Merchant.find(params[:id])
    end

    def show
      @merchant = Merchant.find(params[:id])
      @discount = BulkDiscount.find(params[:discount_id])
    end
  end
end