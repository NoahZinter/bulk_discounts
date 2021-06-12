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

    def new
      @merchant = Merchant.find(params[:id])
    end

    def create
      merchant = Merchant.find(params[:id])
      discount = merchant.bulk_discounts.new(quantity_threshold: params[:quantity_threshold], discount_percent: params[:discount_percent])
      if discount.save
        redirect_to "/merchants/#{merchant.id}/bulk_discounts"
        flash[:success] = "Discount for #{merchant.name} Successfully Created!"
      else
        redirect_to "/merchants/#{merchant.id}/bulk_discounts/new"
        flash[:incomplete] = "Discount NOT Created: Missing/Incorrect Information"
      end
    end

    def destroy
      merchant = Merchant.find(params[:id])
      BulkDiscount.find(params[:discount_id]).destroy
      redirect_to "/merchants/#{merchant.id}/bulk_discounts"
      flash[:deleted] = "Discount Deleted!"
    end
  end
end