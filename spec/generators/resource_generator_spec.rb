require 'spec_helper'
require 'generator_helpers'

describe 'FlexibleAdmin::InstallGenerator' do
  include GeneratorSpec::TestCase
  include GeneratorHelpers

  tests FlexibleAdmin::ResourceGenerator
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
      @output = run_generator ['Post']
    end

    it "creates a posts controller" do
      assert_file 'app/controllers/admin/posts_controller.rb'
    end
    
    it "creates a resources controller" do
      assert_file 'app/controllers/admin/resources_controller.rb'
    end
        
    it "creates an view files" do
      assert_file 'app/views/admin/posts/index.html.erb'
      assert_file 'app/views/admin/posts/new.html.erb'
      assert_file 'app/views/admin/posts/edit.html.erb'
      assert_file 'app/views/admin/posts/_form.html.erb'
    end
        
    it "creates shared form files" do
      assert_file 'app/views/admin/shared/_text_field.html.erb'
      assert_file 'app/views/admin/shared/_text_area_field.html.erb'
      assert_file 'app/views/admin/shared/_select_field.html.erb'
      assert_file 'app/views/admin/shared/_file_field.html.erb'
      assert_file 'app/views/admin/shared/_email_field.html.erb'
      assert_file 'app/views/admin/shared/_cktext_area_field.html.erb'
      assert_file 'app/views/admin/shared/_checkbox_field.html.erb'
      assert_file 'app/views/admin/shared/_error_messages.html.erb'
    end
    
    it "adds an /admin/posts route" do
      assert has_route?("namespace :admin do")
      assert has_route?("resources :posts")
    end
        
  end
  
  context "runs for posts and pages" do
    before :all do
      prepare_destination
      FileUtils.cp_r(::File.expand_path("../../dummy", __FILE__), ::File.expand_path('../', Pathname.new(destination_root))) # copying dummy_app to test directory
      run_generator ['Page']
      @output = run_generator ['Post']
    end

    it "creates controllers" do
      assert_file 'app/controllers/admin/posts_controller.rb'
      assert_file 'app/controllers/admin/pages_controller.rb'
    end
    
    it "creates an resources controller" do
      assert_file 'app/controllers/admin/resources_controller.rb'
    end
        
    it "creates an admin resource views" do
      assert_file 'app/views/admin/posts/index.html.erb'
      assert_file 'app/views/admin/pages/index.html.erb'
    end
    
    it "adds an /admin/posts and /admin/pages route" do
      assert has_route?("namespace :admin do")
      assert has_route?("resources :posts")
      assert has_route?("resources :pages")
    end
  end
  
end
