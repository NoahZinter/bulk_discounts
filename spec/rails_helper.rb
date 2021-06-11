# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'factory_bot_rails'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Capybara.default_driver = :selenium
# Capybara.javascript_driver = :selenium_chrome
# Capybara.default_driver = :selenium_chrome_headless
# Capybara.default_driver = :selenium_headless

RSpec.configure do |config|
  config.before(:each) do
    @hash_array = [
      { 'login' => 'zachjamesgreen',
        'id' => 7_896_916,
        'contributions' => 54 },
      { 'login' => 'BrianZanti',
        'id' => 8_962_411,
        'contributions' => 48 },
      { 'login' => 'NoahZinter',
        'id' => 77_814_101,
        'contributions' => 39 },
      { 'login' => 'timomitchel',
        'id' => 23_040_094,
        'contributions' => 9 },
      { 'login' => 'AlexKlick',
        'id' => 60_951_642,
        'contributions' => 90 },
      { 'login' => 'ztrokey',
        'id' => 20_480_167,
        'contributions' => 50 }
    ]
    @repo_name = {
      "id": 373_926_639,
      "node_id": 'MDEwOlJlcG9zaXRvcnkzNzM5MjY2Mzk=',
      "name": 'bulk_discounts'
    }
    @pulls = 4

    class_double('GithubService', retrieve_name: @repo_name, retrieve_pulls: @pulls,
                                  retrieve_stats: @hash_array).as_stubbed_const

    @holidays = [{"date"=>"2021-01-01",
    "localName"=>"New Year's Day",
    "name"=>"New Year's Day",
    "countryCode"=>"US",
    "fixed"=>false,
    "global"=>true,
    "counties"=>nil,
    "launchYear"=>nil,
    "types"=>["Public"]},
  {"date"=>"2021-01-18",
    "localName"=>"Martin Luther King, Jr. Day",
    "name"=>"Martin Luther King, Jr. Day",
    "countryCode"=>"US",
    "fixed"=>false,
    "global"=>true,
    "counties"=>nil,
    "launchYear"=>nil,
    "types"=>["Public"]},
  {"date"=>"2021-01-20",
    "localName"=>"Inauguration Day",
    "name"=>"Inauguration Day",
    "countryCode"=>"US",
    "fixed"=>true,
    "global"=>false,
    "counties"=>["US-DC", "US-LA", "US-MD", "US-VA"],
    "launchYear"=>nil,
    "types"=>["Public"]},
  {"date"=>"2021-02-15",
    "localName"=>"Presidents Day",
    "name"=>"Washington's Birthday",
    "countryCode"=>"US",
    "fixed"=>false,
    "global"=>true,
    "counties"=>nil,
    "launchYear"=>nil,
    "types"=>["Public"]},
  {"date"=>"2021-05-31",
    "localName"=>"Memorial Day",
    "name"=>"Memorial Day",
    "countryCode"=>"US",
    "fixed"=>false,
    "global"=>true,
    "counties"=>nil,
    "launchYear"=>nil,
    "types"=>["Public"]},
  {"date"=>"2021-07-05",
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
    "types"=>["Public"]},
  {"date"=>"2021-11-11",
    "localName"=>"Veterans Day",
    "name"=>"Veterans Day",
    "countryCode"=>"US",
    "fixed"=>false,
    "global"=>true,
    "counties"=>nil,
    "launchYear"=>nil,
    "types"=>["Public"]},
  {"date"=>"2021-11-25",
    "localName"=>"Thanksgiving Day",
    "name"=>"Thanksgiving Day",
    "countryCode"=>"US",
    "fixed"=>false,
    "global"=>true,
    "counties"=>nil,
    "launchYear"=>1863,
    "types"=>["Public"]},
  {"date"=>"2021-12-24",
    "localName"=>"Christmas Day",
    "name"=>"Christmas Day",
    "countryCode"=>"US",
    "fixed"=>false,
    "global"=>true,
    "counties"=>nil,
    "launchYear"=>nil,
    "types"=>["Public"]}]

    class_double('NagerService', holidays: @holidays).as_stubbed_const
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
