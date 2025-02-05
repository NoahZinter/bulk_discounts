# frozen_string_literal: true

module Merchants
  class DashboardController < ApplicationController
    def index
      @merchant = Merchant.find(params[:id])
      @customers = Customer.top_five(params[:id])
      @items_pending = InvoiceItem.merch_not_shipped(params[:id])
    end
  end
end
