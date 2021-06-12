require 'rails_helper'

describe 'merchant bulk discount new page' do
  before(:each) do
    @merchant = Merchant.find(1)
    BulkDiscount.destroy_all
    @discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 20)
    @discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 25)
    @discount_3 = @merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    visit "/merchants/#{@merchant.id}/bulk_discounts/new"
  end
  it 'contains a form to create a new discount' do
    expect(page).to have_content("Create a New Bulk Discount for #{@merchant.name}")
    expect(page).to have_field('Quantity threshold')
    expect(page).to have_field('Discount percent')
  end
  it 'creates a new discount' do
    fill_in 'Quantity threshold', with: 30
    fill_in 'Discount percent', with: 60
    click_button('Save')

    expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts"
    expect(page).to have_content("Discount for #{@merchant.name} Successfully Created!")
    expect(page).to have_content('Discount Quantity Threshold: 30')
    expect(page).to have_content('Discount Percentage: 60')
    expect(page).to have_link('See Details for Discount Percentage: 60')
  end
  it 'does not create invalid discounts' do
    fill_in 'Discount percent', with: 60
    click_button('Save')

    expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/new"
    expect(page).to have_content "Discount NOT Created: Missing/Incorrect Information"
  end
end