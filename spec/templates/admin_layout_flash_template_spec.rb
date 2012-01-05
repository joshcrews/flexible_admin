require 'spec_helper'

describe "flash.html.erb" do
  
  before(:all) do
    @file =  File.expand_path('../../../lib/generators/flexible_admin/templates/flash.html.erb', __FILE__)
  end
  
  it "should have at least some minimal view code" do
    File.open(@file).read.index("div id=\"flash\"").should be_true
  end
    
end