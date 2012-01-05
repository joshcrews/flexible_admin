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
      assert_file 'app/views/layouts/admin/navigation.html.erb'
    end
    
    it "creates an admin view flash" do
      assert_file 'app/views/layouts/admin/flash.html.erb'
    end
    
    it "creates an admin css file" do
      assert_file 'app/assets/stylesheets/admin/application.css'
    end
    
    it "copies bootstrap in sass" do
      assert_file 'app/assets/stylesheets/admin/bootstrap.sass'
    end
    
    it "adds an /admin route" do
      assert has_route?("get '/admin' => 'admin#index'")
    end
    
    describe "devise AdminUser" do
      
      it "adds devise to Gemfile" do
        assert has_gem?("devise")
      end
      
      it "invokes devise setup" do
        assert @output.match /generate  devise/ # don't know how to run the devise generator in specs, sorry
      end
      
      it "invokes devise generation of AdminUser" do
        assert @output.match /generate  devise AdminUser/ # don't know how to run the devise generator in specs, sorry
        
      end
      
    end

  end
  
  context "already has devise" do
  end

end