BulkDiscount.destroy_all

@merchant_1 = Merchant.find(1)
@bulk_discount_1 = @merchant_1.bulk_discounts.create!(quantity_threshold:10, discount_percent:20)
@bulk_discount_2 = @merchant_1.bulk_discounts.create!(quantity_threshold:15, discount_percent:25)
@bulk_discount_3 = @merchant_1.bulk_discounts.create!(quantity_threshold:20, discount_percent:30)
@bulk_discount_4 = @merchant_1.bulk_discounts.create!(quantity_threshold:25, discount_percent:10)
@bulk_discount_5 = @merchant_1.bulk_discounts.create!(quantity_threshold:30, discount_percent:40)

