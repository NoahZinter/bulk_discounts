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
      discount = merchant.bulk_discounts.new(discount_params)
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

    def edit
      @merchant = Merchant.find(params[:id])
      @discount = BulkDiscount.find(params[:discount_id])
    end

    def update
      merchant = Merchant.find(params[:id])
      discount = BulkDiscount.find(params[:discount_id])
      if discount.update(discount_params)
        redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{discount.id}"
        flash[:success] = "Discount Successfully Edited!"
      else
        redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{discount.id}/edit"
        flash[:failure] = "Discount Not Edited, Missing/Incorrect Fields"
      end
    end

    private

    def discount_params
      params.permit(
        :quantity_threshold,
        :discount_percent
      )
    end
  end
end