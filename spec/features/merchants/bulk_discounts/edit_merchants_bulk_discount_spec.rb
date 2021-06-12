require 'rails_helper'

describe "merchants bulk discount edit page" do
  before(:each) do
    @merchant = Merchant.find(1)
    BulkDiscount.destroy_all
    @discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 20)
    @discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
  end
  it 'contains a form to edit discount' do
    expect(page).to have_content("Edit Discount Percentage #{@discount_1.discount_percent} For #{@merchant.name}")
    expect(page).to have_field('Quantity threshold')
    expect(page).to have_field('Discount percent')
  end

  it 'completing the form edits a discount' do
    
  end

  it 'does not perform invalid edits' do
    
  end
end