require 'spec_helper'

describe 'FlexibleAdmin::InstallGenerator' do
  include GeneratorSpec::TestCase

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
      # @output = run_generator
    end

    it "creates an admin controller" do
      assert_file 'app/views/admin/index.html.erb'
    end
    
    it "creates an admin view layout" do
      assert_file 'app/views/layouts/admin/base.html.erb'
    end

  end

end
