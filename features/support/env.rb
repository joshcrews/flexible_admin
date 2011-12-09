require 'rubygems'
require 'pry'

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../../spec/dummy/config/environment.rb",  __FILE__)

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'flexible_admin'

require 'rspec/expectations'
require 'aruba/cucumber'

require File.expand_path("../../../lib/generators/flexible_admin/install_generator.rb",  __FILE__)

require File.expand_path("../../../spec/dummy/config/environment.rb",  __FILE__)
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "../../../spec/dummy"
require 'cucumber/rails'