# frozen_string_literal: true

require 'rails_helper'

describe 'Merchant Dashboard Page' do
  before(:each) do
    @merch = Merchant.find(1)
    visit "/merchants/#{@merch.id}/dashboard"
  end
  # When I visit my merchant dashboard (/merchants/merchant_id/dashboard)
  # Then I see the name of my merchant
  it 'has the name of the merchant' do
    expect(page).to have_content(@merch.name)
  end

  #   As a merchant,
  # When I visit my merchant dashboard
  # Then I see link to my merchant items index (/merchants/merchant_id/items)
  # And I see a link to my merchant invoices index (/merchants/merchant_id/invoices)
  it 'has 2 links, to merchant items, and merchant invoices' do
    expect(page).to have_link('Items')
    expect(page).to have_link('Invoices')
  end

  #   As a merchant,
  # When I visit my merchant dashboard
  # Then I see the names of the top 5 customers
  # who have conducted the largest number of successful transactions with my merchant
  # And next to each customer name I see the number of successful transactions they have
  # conducted with my merchant
  it 'has the top 5 customers' do
    within('#cust_table') do
      # hardcoded as extra model test
      expect(page).to have_content('Salvatore Deckow')
      expect(page).to have_content('Rachell Pfannerstill')
      expect(page).to have_content('Otelia Daniel')
      expect(page).to have_content('Dean Collins')
      expect(page).to have_content('An Mraz')
    end
  end

  it 'shows number of successful transactions with merchant for the top 5 customers, sorted by number successful transactions' do
    within('#top_cust') do
      expect(page).to have_content(4)
      expect(page).to have_content(2)
      expect(page).to have_content(2)
      expect(page).to have_content(1)
      expect(page).to have_content(1)
      expect('Otelia Daniel').to appear_before('Salvatore Deckow')
      expect('Salvatore Deckow').to appear_before('Rachell Pfannerstill')
    end
  end
  #   As a merchant
  # When I visit my merchant dashboard
  # Then I see a section for "Items Ready to Ship"
  # In that section I see a list of the names of all of my items that
  # have been ordered and have not yet been shipped,
  it 'has a section for items ready to ship, with list of names of items to ship' do
    within('#ship_table') do
      item_ids = [1, 2, 3, 4, 5]
      item_ids.each do |id|
        name = Item.find(id).name
        expect(page).to have_content(name)
      end
    end
  end
  # And next to each Item I see the id of the invoice that ordered my item
  # And each invoice id is a link to my merchant's invoice show page
  it 'each item has the id of the invoice, which is a link to the invoice show page' do
    within('#ship_table') do
      invoice_ids = [44, 43, 35, 29, 29, 27, 21, 15, 8]
      invoice_ids.each do |id|
        expect(page).to have_link(id)
      end
    end
  end
  # As a merchant
  # When I visit my merchant dashboard
  # In the section for "Items Ready to Ship",
  # Next to each Item name I see the date that the invoice was created
  # And I see the date formatted like "Monday, July 18, 2019"
  ##
  it 'has the date of the invoice formatted' do
    within('#ship_table') do
      expect(page).to have_content('June 08, 2021')
    end
  end
  ##
  it 'contains a link to all merchant discounts' do
    expect(page).to have_link("See all discounts for #{@merch.name}")
  end

  it 'clicking link travels to merchant discount index' do
    within('#discount_link') do
      click_link("See all discounts for #{@merch.name}")
    end

    expect(current_path).to eq "/merchants/#{@merch.id}/bulk_discounts"
    expect(page).to have_content("All Discounts for #{@merch.name}")
  end
end
