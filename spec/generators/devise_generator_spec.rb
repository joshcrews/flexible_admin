require 'spec_helper'
require 'generator_helpers'

describe 'FlexibleAdmin::DeviseGenerator' do
  include GeneratorSpec::TestCase
  include GeneratorHelpers

  tests FlexibleAdmin::DeviseGenerator
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
      copy_over_admin_controller_that_install_generator_would_put_in
      @output = run_generator
    end
    
    it "requires authentication in the controller" do
      dummy_app_file('app/controllers/admin_controller.rb').read.index("before_filter :authenticate_admin_user!").should be_true
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
      
      it "makes a formatted sign in page" do
        assert_file 'app/views/admin/admin_users/sessions/new.html.erb'
      end
      
      it "makes a devise session controller for admin users" do
        assert_file 'app/controllers/admin/admin_users/sessions_controller.rb'
      end
            
    end

  end
  
  context "already has devise" do
  end

end
