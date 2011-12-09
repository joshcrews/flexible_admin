Then /^I should have a view named "([^"]*)"$/ do |filename|
  view_exists?(filename).should be_true
end

Then /^I should have a layout named "([^\"]*)"$/ do |filename|
  layout_exists?(filename).should be_true  
end
