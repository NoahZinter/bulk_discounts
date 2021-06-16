require 'rails_helper'

describe 'new holiday discount page' do
  before(:each) do
    @merchant = Merchant.find(1)
    BulkDiscount.destroy_all
    visit "merchants/#{@merchant.id}/bulk_discounts/holiday"
  end
  it 'has a header' do
    expect(page).to have_content("Create a New Holiday Discount for #{@merchant.name}")
  end

  it 'has a form to create a new discount' do
    expect(page).to have_field('Quantity threshold')
    expect(page).to have_field('Discount percent')
  end

  it 'has prefilled values in the form' do
    expect(page).to have_field('Quantity threshold', with: 2)
    expect(page).to have_field('Discount percent', with: 30)
  end

  it 'creates a new standart discount' do
    click_button('Save')

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
    expect(page).to have_content("Discount for #{@merchant.name} Successfully Created!")
    expect(page).to have_content('Discount Quantity Threshold: 2', :count => 1)
    expect(page).to have_content('Discount Percentage: 30', :count => 2)
    expect(page).to have_link('See Details for Discount Percentage: 30')
  end

  it 'can create different discounts' do
    fill_in 'Quantity threshold', with: 15
    fill_in 'Discount percent', with: 50
    click_button('Save')

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
    expect(page).to have_content("Discount for #{@merchant.name} Successfully Created!")
    expect(page).to have_content('Discount Quantity Threshold: 15', :count => 1)
    expect(page).to have_content('Discount Percentage: 50', :count => 2)
    expect(page).to have_link('See Details for Discount Percentage: 50')
  end

  it 'does not create invalid discounts' do
    fill_in 'Quantity threshold', with: 'peanuts'
    fill_in 'Discount percent', with: 'butter'
    click_button('Save')

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
    expect(page).to have_content("Discount NOT Created: Missing/Incorrect Information")
  end
end