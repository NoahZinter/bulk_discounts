# frozen_string_literal: true

module Merchants
  class InvoicesController < ApplicationController
    def index
      @merchant = Merchant.find(params[:id])
      @invoices = Invoice.merchant_invoices(@merchant.id)
    end

    def show
      @invoice = Invoice.find(params[:invoice_id])
      @merchant = Merchant.find(params[:id])
      @customer = Customer.find(@invoice.customer_id)
      @items = Invoice.invoice_items_formatted(params[:invoice_id])
    end
  end
end
