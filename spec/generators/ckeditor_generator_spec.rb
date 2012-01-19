require 'spec_helper'
require 'generator_helpers'

describe 'FlexibleAdmin::CkeditorGenerator' do
  include GeneratorSpec::TestCase
  include GeneratorHelpers

  tests FlexibleAdmin::CkeditorGenerator
  destination ::File.expand_path("../tmp/dummy", __FILE__)

  before :all do
    @rails_root = Rails.configuration.root
    Rails.configuration.root = Pathname.new(destination_root)
  end

  after :all do
    Rails.configuration.root = @rails_root
  end

  context "when Post model with title and body columns" do
    before :all do
      prepare_destination
      FileUtils.cp_r(::File.expand_path("../../dummy", __FILE__), ::File.expand_path('../', Pathname.new(destination_root))) # copying dummy_app to test directory
      copy_over_admin_navigation_that_install_generator_would_put_in
      @output = run_generator ['Post']
    end
    
    it "adds ckeditor gem" do
      assert has_gem?("ckeditor")
      assert has_gem?("paperclip")
      assert has_gem?("aws-s3")
    end
    
    it "runs ckeditor installer" do
      assert @output.match /generate  ckeditor/ # don't know how to run the ckeditor generator in specs, sorry
    end
    
    it "swaps out paperclip code for s3 storage" do
      dummy_app_file('app/models/ckeditor/picture.rb').read.index(":storage => :s3").should be_true
      dummy_app_file('app/models/ckeditor/attachment_file.rb').read.index(":storage => :s3").should be_true
    end
    
    it "tells you what else to do" do
      assert @output.match "rake db:migrate"
      assert @output.match "config/amazon_s3.yml"
    end
                        
  end
  
end
