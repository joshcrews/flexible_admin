# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path('../dummy/config/environment', __FILE__)

require 'generator_spec/test_case'
require 'rspec/rails'
require 'generators/flexible_admin/install_generator'
require 'generators/flexible_admin/resource_generator'
require 'generator_helpers'
require 'pry'

# require 'database_helpers'
# require 'generator_helpers'

# ActionMailer::Base.delivery_method = :test
# ActionMailer::Base.perform_deliveries = true
# ActionMailer::Base.default_url_options[:host] = "example.com"

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers
  config.color_enabled = true
end
