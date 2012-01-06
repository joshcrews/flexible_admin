require 'spec_helper'

describe "admin_layout.html.erb" do
  
  before(:all) do
    @file =  File.expand_path("../../../lib/generators/flexible_admin/templates/#{self.class.description}", __FILE__)
  end
  
  it "should reference admin css" do
    File.open(@file).read.index("<%%= stylesheet_link_tag 'admin/application' %>").should be_true
  end
  
  it "should reference navigation partial" do
    File.open(@file).read.index("<%%= render 'layouts/admin/navigation' %>").should be_true
  end
  
  it "should reference navigation partial" do
    File.open(@file).read.index("<%%= render 'layouts/admin/flash', :flash => flash %>").should be_true
  end
  
end