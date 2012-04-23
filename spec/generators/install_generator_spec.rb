require 'spec_helper'
require 'generator_helpers'

describe 'FlexibleAdmin::InstallGenerator' do
  include GeneratorSpec::TestCase
  include GeneratorHelpers

  tests FlexibleAdmin::InstallGenerator
  destination ::File.expand_path("../tmp/dummy", __FILE__)

  before :all do
    @rails_root = Rails.configuration.root
    Rails.configuration.root = Pathname.new(destination_root)
  end

  after :all do
    Rails.configuration.root = @rails_root
  end

  context "when new app" do
    before :all do
      prepare_destination
      FileUtils.cp_r(::File.expand_path("../../dummy", __FILE__), ::File.expand_path('../', Pathname.new(destination_root))) # copying dummy_app to test directory
      @output = run_generator
    end

    it "creates an admin view" do
      assert_file 'app/views/admin/index.html.erb'
    end
    
    it "creates an admin controller" do
      assert_file 'app/controllers/admin_controller.rb'
    end
    
    it "creates an admin view layout" do
      assert_file 'app/views/layouts/admin/base.html.erb'
    end
    
    it "creates an admin helper" do
      assert_file 'app/helpers/admin_helper.rb'
    end
    
    it "creates an admin view navigation" do
      assert_file 'app/views/layouts/admin/_navigation.html.erb'
    end
    
    it "creates an admin view flash" do
      assert_file 'app/views/layouts/admin/_flash.html.erb'
    end
    
    it "creates an admin css files" do
      assert_file 'app/assets/stylesheets/admin/application.css'
      assert_file 'app/assets/stylesheets/admin/bootstrap.css'
      assert_file 'app/assets/stylesheets/admin/datatables/demo_table.css'
      assert_file 'app/assets/stylesheets/admin/admin.sass'
      assert_file 'app/assets/images/admin/admin-background.png'
    end
    
    it "creates shared form files" do
      assert_file 'app/views/admin/shared/_text_field.html.erb'
      assert_file 'app/views/admin/shared/_datepicker_text_field.html.erb'
      assert_file 'app/views/admin/shared/_text_area_field.html.erb'
      assert_file 'app/views/admin/shared/_select_field.html.erb'
      assert_file 'app/views/admin/shared/_file_field.html.erb'
      assert_file 'app/views/admin/shared/_email_field.html.erb'
      assert_file 'app/views/admin/shared/_cktext_area_field.html.erb'
      assert_file 'app/views/admin/shared/_checkbox_field.html.erb'
      assert_file 'app/views/admin/shared/_error_messages.html.erb'
      assert_file 'app/views/admin/shared/_password_field.html.erb'
    end
    
    it "creates datatables images" do
      assert_file 'app/assets/images/admin/datatables/back_disabled.jpg'
      assert_file 'app/assets/images/admin/datatables/back_enabled.jpg'
      assert_file 'app/assets/images/admin/datatables/forward_disabled.jpg'
      assert_file 'app/assets/images/admin/datatables/forward_enabled.jpg'      
      assert_file 'app/assets/images/admin/datatables/sort_asc.png'
      assert_file 'app/assets/images/admin/datatables/sort_desc.png'
      assert_file 'app/assets/images/admin/datatables/sort_both.png'
      assert_file 'app/assets/images/admin/datatables/sort_asc_disabled.png'
      assert_file 'app/assets/images/admin/datatables/sort_desc_disabled.png'
    end
    
    it "copies bootstrap in css" do
      assert_file 'app/assets/stylesheets/admin/bootstrap.css'
    end
    
    it "creates admin javascript files" do
      assert_file 'app/assets/javascripts/admin/application.js'
      assert_file 'app/assets/javascripts/admin/app.js'
      assert_file 'app/assets/javascripts/admin/jquery.dataTables.js'
    end
    
    it "copies jquery-ui" do
      assert_file 'app/assets/javascripts/admin/jquery-ui-1.8.17.custom.min.js'
      assert_file 'app/assets/stylesheets/ui-lightness/jquery-ui-1.8.17.custom.css'
    end
        
    it "adds an /admin route" do
      assert has_route?("get '/admin' => 'admin#index'")
    end

  end

end
