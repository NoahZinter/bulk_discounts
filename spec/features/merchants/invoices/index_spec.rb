require 'rails_helper'

RSpec.describe 'merchant invoice Index page' do

  # Merchant Invoices Index

  # As a merchant,
  # When I visit my merchant's invoices index (/merchants/merchant_id/invoices)
  # Then I see all of the invoices that include at least one of my merchant's items
  # And for each invoice I see its id
  # And each id links to the merchant invoice show page

  it 'has all of the invoice ids from this merchants invoices as links to the invoices ' do
    merch = Merchant.all[3]
    invoice_ids = [2, 5, 8, 9, 10, 14, 18, 19, 20, 21, 22, 28, 29, 30, 33, 35]
    invoice_not = [1, 3, 4, 6, 7]
    visit "/merchants/#{merch.id}/invoices"
    invoice_ids.each do |id|
      expect(page).to have_link(id.to_s, :exact => true)
    end
    invoice_not.each do |id|
      expect(page).to_not have_link(id.to_s, :exact => true)
    end
  end

  #   Merchant Invoice Show Page: Update Item Status

  # As a merchant
  # When I visit my merchant invoice show page
  # I see that each invoice item status is a select field
  # And I see that the invoice item's current status is selected
  # When I click this select field,
  # Then I can select a new status for the Item,
  # And next to the select field I see a button to "Update Item Status"
  # When I click this button
  # I am taken back to the merchant invoice show page
  # And I see that my Item's status has now been updated

  
end