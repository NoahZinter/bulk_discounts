require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant)}
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity_threshold) }
    it { should validate_presence_of(:discount_percent) }
    it { should validate_numericality_of(:quantity_threshold) }
    it { should validate_numericality_of(:discount_percent) }
  end
end
