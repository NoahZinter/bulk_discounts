BulkDiscount.destroy_all
@merchant_1 = Merchant.find(1)
@merchant_2 = Merchant.find(2)
@merchant_3 = Merchant.find(3)

@discount_1 = @merchant_3.bulk_discounts.create!(quantity_threshold: 5, discount_percent: 5)
@discount_2 = @merchant_3.bulk_discounts.create!(quantity_threshold: 20, discount_percent: 30)
@discount_3 = @merchant_3.bulk_discounts.create!(quantity_threshold: 70, discount_percent: 50)
@discount_4 = @merchant_1.bulk_discounts.create!(quantity_threshold: 15, discount_percent: 15)
@discount_5 = @merchant_2.bulk_discounts.create!(quantity_threshold: 25, discount_percent: 45)

