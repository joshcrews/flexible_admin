$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flexible_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flexible_admin"
  s.version     = FlexibleAdmin::VERSION
  s.authors     = ["Josh Crews"]
  s.email       = ["josh@joshcrews.com"]
  s.homepage    = "http://github.com/joshcrews/flexible_admin"
  s.summary     = "Admin for Rails 3.1 apps"
  s.description = "Designed to handle admin basics and allow easy customization"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "pry"
  
end
