# frozen_string_literal: true

require_relative 'config/application'
require 'csv'
Rails.application.load_tasks

namespace :csv_load do
  desc 'load customer csv'
  task customers: :environment do
    csv_path = 'db/data/customers.csv'
    i = 1
    CSV.foreach(csv_path, headers: true) do |row|
      if Customer.create! row.to_h
        print "#{i} Customer Records Done\r"
        i += 1
      end
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
    print "\n"
  end

  desc 'load invoices csv'
  task invoices: :environment do
    csv_path = 'db/data/invoices.csv'
    i = 1
    CSV.foreach(csv_path, headers: true) do |row|
      if Invoice.create! row.to_h
        print "#{i} Invoice Records Done\r"
        i += 1
      end
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
    print "\n"
  end

  desc 'load items csv'
  task items: :environment do
    csv_path = 'db/data/items.csv'
    i = 1
    CSV.foreach(csv_path, headers: true) do |row|
      if Item.create! row.to_h
        print "#{i} Item Records Done\r"
        i += 1
      end
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
    print "\n"
  end

  desc 'load invoice_items csv'
  task invoice_items: :environment do
    csv_path = 'db/data/invoice_items.csv'
    i = 1
    CSV.foreach(csv_path, headers: true) do |row|
      if InvoiceItem.create! row.to_h
        print "#{i} InvoiceItem Records Done\r"
        i += 1
      end
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
    print "\n"
  end

  desc 'load merchants csv'
  task merchants: :environment do
    csv_path = 'db/data/merchants.csv'
    i = 1
    CSV.foreach(csv_path, headers: true) do |row|
      if Merchant.create! row.to_h
        print "#{i} Merchant Records Done\r"
        i += 1
      end
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
    print "\n"
  end

  desc 'load bulk_discounts csv'
  task bulk_discounts: :environment do
    csv_path = 'db/data/bulk_discounts.csv'
    i = 1
    CSV.foreach(csv_path, headers: true) do |row|
      if BulkDiscount.create! row.to_h
        print "#{i} BulkDiscount Records Done\r"
        i += 1
      end
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('bulk_discounts')
    print "\n"
  end

  desc 'load transactions csv'
  task transactions: :environment do
    csv_path = 'db/data/transactions.csv'
    i = 1
    CSV.foreach(csv_path, headers: true) do |row|
      if Transaction.create! row.to_h
        print "#{i} Transaction Records Done\r"
        i += 1
      end
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
    print "\n"
  end

  desc 'run all csv files'
  task all: %w[customers merchants invoices items invoice_items transactions bulk_discounts] do
    Rails.env = 'development'
    print "All CSV files loaded. \n"
  end
end

# TODO: refactor below code to use a method

desc "load test data csv's"
task load_test_data: :environment do
  Rails.env = 'test'
  files = {
    'Customer' => 'db/data/test_data/customers.csv',
    'Merchant' => 'db/data/test_data/merchants.csv',
    'Invoice' => 'db/data/test_data/invoices.csv',
    'Item' => 'db/data/test_data/items.csv',
    'InvoiceItem' => 'db/data/test_data/invoice_items.csv',
    'Transaction' => 'db/data/test_data/transactions.csv'
  }
  files.each do |table, filename|
    csv = CSV.open(filename, 'a+') do |row|
      case table
      when 'Customer'
        Customer.all.each do |customer|
          attributes = customer.attributes
          row << attributes.values
        end
      when 'Merchant'
        Merchant.all.each do |customer|
          attributes = customer.attributes
          row << attributes.values
        end
      when 'Invoice'
        Invoice.all.each do |customer|
          attributes = customer.attributes
          row << attributes.values
        end
      when 'Item'
        Item.all.each do |customer|
          attributes = customer.attributes
          row << attributes.values
        end
      when 'InvoiceItem'
        InvoiceItem.all.each do |customer|
          attributes = customer.attributes
          row << attributes.values
        end
      else
        Transaction.all.each do |customer|
          attributes = customer.attributes
          row << attributes.values
        end
      end
    end
  end
end

desc 'load test data to database'
task load_test_data_seed: :environment do
  Rails.env = 'test'
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  customers = []
  items = []
  10.times do
    customers << Customer.create!(FactoryBot.attributes_for(:customer))
  end

  5.times do
    m = Merchant.create!(FactoryBot.attributes_for(:merchant))
    items << m.items.create!(FactoryBot.attributes_for(:item))
    items << m.items.create!(FactoryBot.attributes_for(:item))
    items << m.items.create!(FactoryBot.attributes_for(:item))
    items << m.items.create!(FactoryBot.attributes_for(:item))
    items << m.items.create!(FactoryBot.attributes_for(:item))
  end

  customers.each do |customer|
    5.times do
      attrs = FactoryBot.attributes_for(:invoice)
      attrs[:customer_id] = customer.id
      invoice = Invoice.create!(attrs)
      invoice.transactions.create!(FactoryBot.attributes_for(:transaction))
      4.times do
        item = items.sample
        attrs = FactoryBot.attributes_for(:invoice_item)
        attrs[:item_id] = item.id
        attrs[:invoice_id] = invoice.id
        InvoiceItem.create!(attrs)
      end
    end
  end
end

desc 'load csv data to database'
task csv_test_seed: :environment do
  Rails.env = 'test'
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  csv_paths = ['db/data/test_data/customers.csv',
               'db/data/test_data/merchants.csv',
               'db/data/test_data/invoices.csv',
               'db/data/test_data/items.csv',
               'db/data/test_data/invoice_items.csv',
               'db/data/test_data/transactions.csv']
  csv_paths.each do |path|
    CSV.foreach(path, headers: true) do |row|
      case path
      when 'db/data/test_data/customers.csv'
        Customer.create! row.to_h
      when 'db/data/test_data/merchants.csv'
        Merchant.create! row.to_h
      when 'db/data/test_data/invoices.csv'
        Invoice.create! row.to_h
      when 'db/data/test_data/items.csv'
        Item.create! row.to_h
      when 'db/data/test_data/invoice_items.csv'
        InvoiceItem.create! row.to_h
      else
        Transaction.create! row.to_h
      end
    end
  end
end

#
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from customers) To STDOUT With CSV HEADER DELIMITER ',';" > ./db/data/test_data/customers.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from merchants) To STDOUT With CSV HEADER DELIMITER ',';" > ./db/data/test_data/merchants.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from invoices) To STDOUT With CSV HEADER DELIMITER ',';" > ./db/data/test_data/invoices.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from items) To STDOUT With CSV HEADER DELIMITER ',';" > ./db/data/test_data/items.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from invoice_items) To STDOUT With CSV HEADER DELIMITER ',';" > ./db/data/test_data/invoice_items.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from transactions) To STDOUT With CSV HEADER DELIMITER ',';" > ./db/data/test_data/transactions.csv
#
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from customers) To STDOUT With CSV DELIMITER ',';" > ./db/data/test_data/customers.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from merchants) To STDOUT With CSV DELIMITER ',';" > ./db/data/test_data/merchants.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from invoices) To STDOUT With CSV DELIMITER ',';" > ./db/data/test_data/invoices.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from items) To STDOUT With CSV DELIMITER ',';" > ./db/data/test_data/items.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from invoice_items) To STDOUT With CSV DELIMITER ',';" > ./db/data/test_data/invoice_items.csv
# psql -U zach -d little-etsy-shop_test -c "Copy (select * from transactions) To STDOUT With CSV DELIMITER ',';" > ./db/data/test_data/transactions.csv
