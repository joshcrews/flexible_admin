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

  context "when Post model with title and body columns" do
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
    
    it "customizes the form for your models columns" do
      dummy_app_file('app/views/admin/posts/_form.html.erb').read.index("<%= render 'admin/shared/text_field', :f => f, :what => :title %>").should be_true
      dummy_app_file('app/views/admin/posts/_form.html.erb').read.index("<%= render 'admin/shared/text_area_field', :f => f, :what => :body %>").should be_true
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
  
  context "when Speaker model with all kinds of columns" do
    before :all do
      prepare_destination
      FileUtils.cp_r(::File.expand_path("../../dummy", __FILE__), ::File.expand_path('../', Pathname.new(destination_root))) # copying dummy_app to test directory
      @output = run_generator ['Speaker']
    end
    
    it "customizes the form for your models columns" do
      dummy_app_file('app/views/admin/speakers/_form.html.erb').read.index("<%= render 'admin/shared/text_field', :f => f, :what => :name %>").should be_true
      dummy_app_file('app/views/admin/speakers/_form.html.erb').read.index("<%= render 'admin/shared/text_area_field', :f => f, :what => :description %>").should be_true
      dummy_app_file('app/views/admin/speakers/_form.html.erb').read.index("<%= render 'admin/shared/checkbox_field', :f => f, :what => :active %>").should be_true
      dummy_app_file('app/views/admin/speakers/_form.html.erb').read.index("<%= render 'admin/shared/email_field', :f => f, :what => :email %>").should be_true
      dummy_app_file('app/views/admin/speakers/_form.html.erb').read.index("<%= render 'admin/shared/text_field', :f => f, :what => :password %>").should be_true
      # dummy_app_file('app/views/admin/speakers/_form.html.erb').read.index("<%= render 'admin/shared/select_field', :f => f, :what => :state %>").should be_true
      dummy_app_file('app/views/admin/speakers/_form.html.erb').read.index("<%= render 'admin/shared/file_field', :f => f, :what => :profile_pic %>").should be_true
    end
    
    it "doesnt make form fields for unwanted database columns" do
      [:id, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at , :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at].each do |column|
        dummy_app_file('app/views/admin/speakers/_form.html.erb').read.index("#{column}").should be_nil
      end      
    end
                
  end
  
end
