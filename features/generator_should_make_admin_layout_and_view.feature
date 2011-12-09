Feature: Generator should make admin layout and view
  In order to given an attractive admin to Rails apps
  As a generator
  I want to make an admin layout
  
Scenario: Generate a layout    
  When I run `rails new dummy_app`
  When I cd to "dummy_app"
  When I run `rails g flexible_admin:install`

  Then I should have a layout named "admin/base.html.erb"
  Then I should have a view named "admin/index.html.erb"
