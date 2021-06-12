require 'rails_helper'


describe 'merchant bulk discounts index' do
  before(:each) do
    @merchant = Merchant.find(1)
    BulkDiscount.destroy_all
    @discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, discount_percent: 20)
    @discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 25)
    @discount_3 = @merchant.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
    visit "/merchants/#{@merchant.id}/bulk_discounts"
  end

  it 'displays all bulk discounts' do
    expect(page).to have_content('Discount Quantity Threshold: 10')
    expect(page).to have_content('Discount Quantity Threshold: 15')
    expect(page).to have_content('Discount Quantity Threshold: 20')
    expect(page).to have_content('Discount Percentage: 20')
    expect(page).to have_content('Discount Percentage: 25')
    expect(page).to have_content('Discount Percentage: 30')
  end

  it 'displays the percentage discount' do
    expect(page).to have_content('Discount Percentage: 20')
    expect(page).to have_content('Discount Percentage: 25')
    expect(page).to have_content('Discount Percentage: 30')
  end

  it 'displays the quantity threshold' do
    expect(page).to have_content('Discount Quantity Threshold: 10')
    expect(page).to have_content('Discount Quantity Threshold: 15')
    expect(page).to have_content('Discount Quantity Threshold: 20')
  end

  it 'has a link to each discount show page' do
    expect(page).to have_link('See Details for Discount Percentage: 20')
    expect(page).to have_link('See Details for Discount Percentage: 25')
    expect(page).to have_link('See Details for Discount Percentage: 30')
  end

  it 'clicking the link travels to show page' do
    click_link('See Details for Discount Percentage: 20')

    expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}"
  end

  it 'displays upcoming holidays' do
    @holidays = [{"date"=>"2021-07-05",
                "localName"=>"Independence Day",
                "name"=>"Independence Day",
                "countryCode"=>"US",
                "fixed"=>false,
                "global"=>true,
                "counties"=>nil,
                "launchYear"=>nil,
                "types"=>["Public"]},
              {"date"=>"2021-09-06",
                "localName"=>"Labor Day",
                "name"=>"Labour Day",
                "countryCode"=>"US",
                "fixed"=>false,
                "global"=>true,
                "counties"=>nil,
                "launchYear"=>nil,
                "types"=>["Public"]},
              {"date"=>"2021-10-11",
                "localName"=>"Columbus Day",
                "name"=>"Columbus Day",
                "countryCode"=>"US",
                "fixed"=>false,
                "global"=>false,
                "counties"=>
                ["US-AL",
                  "US-AZ",
                  "US-CO",
                  "US-CT",
                  "US-DC",
                  "US-GA",
                  "US-ID",
                  "US-IL",
                  "US-IN",
                  "US-IA",
                  "US-KS",
                  "US-KY",
                  "US-LA",
                  "US-ME",
                  "US-MD",
                  "US-MA",
                  "US-MS",
                  "US-MO",
                  "US-MT",
                  "US-NE",
                  "US-NH",
                  "US-NJ",
                  "US-NM",
                  "US-NY",
                  "US-NC",
                  "US-OH",
                  "US-OK",
                  "US-PA",
                  "US-RI",
                  "US-SC",
                  "US-TN",
                  "US-UT",
                  "US-VA",
                  "US-WV"],
                  "launchYear"=>nil,
                  "types"=>["Public"]}]
    class_double('Holidays', next_three: @holidays).as_stubbed_const

    expect(page).to have_content("Next 3 Holidays")
    expect(page).to have_content("Holiday: Independence Day Is on: 2021-07-05")
  end

  it 'has a link to create new discount' do
    expect(page).to have_button('Create New Discount')
  end

  it 'clicking create new discount travels to new discount page' do
    click_button('Create New Discount')
    expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/new"
  end
end