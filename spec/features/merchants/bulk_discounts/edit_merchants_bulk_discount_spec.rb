require 'rails_helper'

describe "merchants bulk discount edit page" do
  before(:each) do
    @merchant = Merchant.find(1)
    BulkDiscount.destroy_all
    @discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 20)
    @discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
  end
  it 'has a header' do
    expect(page).to have_content("Edit Discount Percentage #{@discount_1.discount_percent} For #{@merchant.name}")
  end
  it 'contains a form to edit discount' do
    expect(page).to have_field('Quantity threshold')
    expect(page).to have_field('Discount percent')
  end

  it 'completing the form edits a discount' do
    fill_in 'Quantity threshold', :with => 15
    fill_in 'Discount percent', :with => 25
    click_button('Save')

    expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}"
    expect(page).to have_content("Discount Quantity Threshold: 15")
    expect(page).to have_content("Discount Percentage: 25")
    expect(page).to have_content("Discount Successfully Edited!")
  end

  it 'does not perform invalid edits' do
    fill_in 'Quantity threshold', :with => 'Abba'
    fill_in 'Discount percent', :with => 25
    click_button('Save')

    expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
    expect(page).to have_content("Discount Not Edited, Missing/Incorrect Fields")
  end
end