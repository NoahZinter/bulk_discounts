# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Invoice Show' do
  #   As an admin,
  # When I visit an admin invoice show page
  # Then I see information related to that invoice including:

  # Invoice id
  # Invoice status
  # Invoice created_at date in the format "Monday, July 18, 2019"
  # Customer first and last name
  it 'shows the attributes of and invoice' do
    invoice = Invoice.first
    customer = Customer.first

    visit "/admin/invoices/#{invoice.id}"

    expect(page).to have_content(invoice.id)
    expect(page).to have_content(invoice.status)
    expect(page).to have_content(invoice.created_at.strftime('%A, %B %d, %Y'))
    expect(page).to have_content(customer.first_name)
    expect(page).to have_content(customer.last_name)
  end

  it 'updates an invoice' do
    invoice = Invoice.find(1)
    visit "/admin/invoices/#{invoice.id}"

    expect(page).to have_select('invoice_status', with_options:['in progress', 'cancelled', 'completed'])
    select 'in progress', from: 'invoice_status'
    click_on 'Update Invoice'

    expect(page).to have_select('invoice_status', with_options:['in progress', 'cancelled', 'completed'])
    select 'completed', from: 'invoice_status'
    click_on 'Update Invoice'

    expect(invoice.status).to eq 'completed'
  end

  # As an admin
  # When I visit an admin invoice show page
  # Then I see all of the items on the invoice including:

  # Item name
  # The quantity of the item ordered
  # The price the Item sold for
  # The Invoice Item status
  it 'shows the items attributes' do
    invoice = Invoice.first

    visit "/admin/invoices/#{invoice.id}"

    expect(page).to have_content(invoice.items[0].name)
    expect(page).to have_content(invoice.items[1].name)
    expect(page).to have_content(invoice.items[2].name)
    expect(page).to have_content(invoice.items[3].name)
    expect(page).to have_content(invoice.invoice_items[0].quantity)
    expect(page).to have_content(invoice.invoice_items[1].quantity)
    expect(page).to have_content(invoice.invoice_items[2].quantity)
    expect(page).to have_content(invoice.invoice_items[3].quantity)
    expect(page).to have_content((invoice.invoice_items[0].unit_price.to_f / 100).round(2))
    expect(page).to have_content((invoice.invoice_items[1].unit_price.to_f / 100).round(2))
    expect(page).to have_content((invoice.invoice_items[2].unit_price.to_f / 100).round(2))
    expect(page).to have_content((invoice.invoice_items[3].unit_price.to_f / 100).round(2))
    expect(page).to have_content(invoice.invoice_items[0].status)
    expect(page).to have_content(invoice.invoice_items[1].status)
    expect(page).to have_content(invoice.invoice_items[2].status)
    expect(page).to have_content(invoice.invoice_items[3].status)
  end

  it 'shows the total revenue' do
    invoice = Invoice.first
    visit "/admin/invoices/#{invoice.id}"

    expect(page).to have_content("Total Revenue For This Invoice: $626.91")
  end

  it 'shows the discounted revenue' do
    invoice = Invoice.first
    merchant = Merchant.find(3)
    BulkDiscount.destroy_all
    merchant.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
    merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    merchant.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
    visit "/admin/invoices/#{invoice.id}"

    expect(page).to have_content("Discounted Revenue For This Invoice: $521.76")
  end

  it 'shows the same revenue under discounted revenue if no discount' do
    invoice = Invoice.first
    visit "/admin/invoices/#{invoice.id}"

    expect(page).to have_content("Discounted Revenue For This Invoice: $626.91")
  end
end
