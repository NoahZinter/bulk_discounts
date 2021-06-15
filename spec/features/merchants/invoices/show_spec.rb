# frozen_string_literal: true

require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'merchant invoice show page' do
  before(:each) do
    # Capybara.default_driver = :selenium_headless
  end
  #   As a merchant
  # When I visit my merchant invoice show page
  # Then I see the total revenue that will be generated from all of my items on the invoice
  it 'shows the  total revenue that will be generated from all of my items on the invoice' do
    merchant_1 = Merchant.create!(name: 'Fake Merchant')

    item_1 = Item.create!(name: 'first', description: 'number 1', unit_price: 100, merchant_id: merchant_1.id)
    item_2 = Item.create!(name: 'second', description: 'number 2', unit_price: 200, merchant_id: merchant_1.id)
    item_3 = Item.create!(name: 'third', description: 'number 3', unit_price: 300, merchant_id: merchant_1.id)

    customer_1 = Customer.create!(first_name: '1 cust', last_name: 'First cust')

    invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id, id: 51)

    invoice_item_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 100,
                                         status: 2, id: 201)
    invoice_item_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 1, unit_price: 200,
                                         status: 2, id: 202)
    invoice_item_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 1, unit_price: 300,
                                         status: 2, id: 203)
    visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"
    expect(page).to have_content('Invoice Revenue: $6.0')
  end

  # As a merchant
  # When I visit my merchant's invoice show page(/merchants/merchant_id/invoices/invoice_id)
  # Then I see information related to that invoice including:
  # Invoice id
  # Invoice status
  # Invoice created_at date in the format "Monday, July 18, 2019"
  # Customer first and last name

  it 'has the invoice id, status, date created formatted, customer first and last name' do
    invoice = Invoice.all[10]
    items = invoice.invoice_items_formatted
    customer = Customer.find(invoice.customer_id)
    visit "/merchants/#{items[0].merchant_id}/invoices/#{invoice.id}"
    expect(page).to have_content(invoice.id)
    expect(page).to have_content(invoice.status)
    expect(page).to have_content(invoice.formatted_time)
    expect(page).to have_content(customer.first_name)
    expect(page).to have_content(customer.last_name)
  end

  #   Merchant Invoice Show Page: Invoice Item Information

  # As a merchant
  # When I visit my merchant invoice show page
  # Then I see all of my items on the invoice including:
  # - Item name
  # - The quantity of the item ordered
  # - The price the Item sold for
  # - The Invoice Item status
  # And I do not see any information related to Items for other merchants

  it 'has the invoice items information: name, quantity ordered, price, and invoice item status -- only has for this merchant' do
    invoice = Invoice.all[10]
    items = invoice.invoice_items_formatted
    visit "/merchants/#{items[0].merchant_id}/invoices/#{invoice.id}"
    items.each do |item|
      expect(page).to have_content(item.name)
      expect(page).to have_content(item.quantity)
      expect(page).to have_content(item.unit_price.to_f / 100)
      expect(page).to have_content(item.status)
    end
  end

  #   As a merchant
  # When I visit my merchant invoice show page
  # I see that each invoice item status is a select field
  # And I see that the invoice item's current status is selected

  it 'has the invoice item status as a select field, set to current status' do
    invoice = Invoice.all[10]
    items = invoice.invoice_items_formatted
    visit "/merchants/#{items[0].merchant_id}/invoices/#{invoice.id}"
    within('.table') do
      # map item statuses and status btn values, check too see if matches
      statuses = items.map(&:status)
      btn_values = page.all('button').each_with_index.map { |btn, _i| statuses[1] == btn.text }
      btn_values.each do |val|
        expect(val).to eq true
      end
    end
  end

  # When I click this select field,
  # Then I can select a new status for the Item,
  # And next to the select field I see a button to "Update Item Status"
  # When I click this button
  # I am taken back to the merchant invoice show page
  # And I see that my Item's status has now been updated

  xit 'allows changing the item status' do
    invoice = Invoice.all[10]
    items = invoice.invoice_items_formatted
    visit "/merchants/#{items[0].merchant_id}/invoices/#{invoice.id}"
    # within("#item_id-#{items.first.id}") do
    #   find("#f#{items.first.id}").click
    #     page.select "shipped"
    # end
    # save_and_open_page
    within("#item_id-#{items.first.id}") do
      within("#f#{items.first.id}") do
        within("dropdown-#{items.first.id}") do
          click_link('shipped')
        end
      end
    end
    expect(first('.status').text).to eq 'shipped'
  end

  it 'contains links to applied discounts' do
    invoice = Invoice.find(1)
    items = invoice.items
    merchant = Merchant.find(3)
    BulkDiscount.destroy_all
    discount_1 = merchant.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
    discount_2 = merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    discount_3 = merchant.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
    discount_9 = merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 30)
    discount_10 = merchant.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
    discount_11 = merchant.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
    visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

    expect(items[0].merchant_id).to eq 1
    expect(items[1].merchant_id).to eq 3
    expect(items[2].merchant_id).to eq 3
    expect(items[3].merchant_id).to eq 3
    expect(page).not_to have_link("#{items[0].name} applied discount")
    expect(page).to have_link("#{items[1].name} applied discount")
    expect(page).to have_link("#{items[2].name} applied discount")
    expect(page).to have_link("#{items[3].name} applied discount")
  end

  it 'clicking the link travels to discount show page' do
    invoice = Invoice.find(1)
    items = invoice.items
    merchant = Merchant.find(3)
    BulkDiscount.destroy_all
    discount_1 = merchant.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
    discount_2 = merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    discount_3 = merchant.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
    discount_9 = merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 30)
    discount_10 = merchant.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
    discount_11 = merchant.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
    visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

    click_link("#{items[2].name} applied discount")
    expect(current_path).to eq "/merchants/#{merchant.id}/bulk_discounts/#{discount_10.id}"
  end

  it 'does not show discount links for undiscounted items' do
    invoice = Invoice.find(1)
    items = invoice.items
    merchant = Merchant.find(3)
    BulkDiscount.destroy_all
    discount_1 = merchant.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
    discount_2 = merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    discount_3 = merchant.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
    discount_9 = merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 30)
    discount_10 = merchant.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
    discount_11 = merchant.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
    visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

    expect(page).not_to have_link("#{items[0].name} applied discount")
  end

  it 'shows total merchant revenue' do
    invoice = Invoice.find(1)
    items = invoice.items
    merchant = Merchant.find(3)
    BulkDiscount.destroy_all
    discount_1 = merchant.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
    discount_2 = merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    discount_3 = merchant.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
    discount_9 = merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 30)
    discount_10 = merchant.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
    discount_11 = merchant.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
    visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

    expect(page).to have_content("Merchant Revenue: For #{merchant.name}: $ 308.25")
  end

  it 'shows discounted merchant revenue' do
    invoice = Invoice.find(1)
    items = invoice.items
    merchant = Merchant.find(3)
    BulkDiscount.destroy_all
    discount_1 = merchant.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
    discount_2 = merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    discount_3 = merchant.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
    discount_9 = merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 30)
    discount_10 = merchant.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
    discount_11 = merchant.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
    visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

    expect(page).to have_content("Merchant Discounted Revenue: For #{merchant.name}: $ 176.28")
  end

  it 'Shows discounted revenue for merchants with no discounts' do
    invoice = Invoice.find(1)
    items = invoice.items
    merchant = Merchant.find(3)
    no_discount_merchant = Merchant.find(1)
    BulkDiscount.destroy_all
    discount_1 = merchant.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
    discount_2 = merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    discount_3 = merchant.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
    discount_9 = merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 30)
    discount_10 = merchant.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 75)
    discount_11 = merchant.bulk_discounts.create!(quantity_threshold: 30, discount_percent: 5)
    visit "/merchants/#{no_discount_merchant.id}/invoices/#{invoice.id}"

    save_and_open_page

    expect(page).to have_content("Merchant Revenue: For #{no_discount_merchant.name}: $ 318.66")
    expect(page).to have_content("Merchant Discounted Revenue: For #{no_discount_merchant.name}: $ 318.66")
  end
end
