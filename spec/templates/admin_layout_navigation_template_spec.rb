require 'spec_helper'

describe "navigation.html.erb" do
  
  before(:all) do
    @file =  File.expand_path("../../../lib/generators/flexible_admin/templates/#{self.class.description}", __FILE__)
  end
  
  it "should link to admin home" do
    File.open(@file).read.index("href=\"/admin\"").should be_true
  end
    
end