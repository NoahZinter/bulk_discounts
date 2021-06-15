require 'rails_helper'

describe 'merchant bulk discount show' do
  before(:each) do
    @merchant = Merchant.find(1)
    @discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 20)
    @discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 25)
    @discount_3 = @merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}"
  end
  it 'has a header' do
    expect(page).to have_content("#{@merchant.name}'s Discount Details")
  end

  it 'displays the quantity threshold' do
    expect(page).to have_content("Discount Quantity Threshold: #{@discount_1.quantity_threshold}")
  end

  it 'displays the percentage discount' do
    expect(page).to have_content("Discount Percentage: #{@discount_1.discount_percent}")
  end

  it 'contains a link to edit the discount' do
    expect(page).to have_link('Edit This Discount')
  end

  it 'clicking the link travels to discount edit page' do
    click_link("Edit This Discount")

    expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
  end
end
