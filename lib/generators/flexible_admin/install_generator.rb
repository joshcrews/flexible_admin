require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks

module FlexibleAdmin
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "flexible_admin installation generator"
    
    def create_admin_view
      template "admin_index.html.erb", "app/views/admin/index.html.erb"
    end
    
    def create_admin_layout_view
      template "admin_layout.html.erb", "app/views/layouts/admin/base.html.erb"
    end
    
    def create_bootstrap_stylesheet
      template "bootstrap.sass", "app/assets/stylesheets/admin/bootstrap.sass"
    end
    
    def make_admin_route
      route("get '/admin' => 'admin#index'")
    end
    
    def create_admin_controller
      template "admin_controller.rb", "app/controllers/admin_controller.rb"
    end
    
    def devise
      unless defined?(Devise)
        say "Adding devise gem to your Gemfile:"
        append_file "Gemfile", "\n", :force => true
        gem 'devise'
      end
      
      unless File.exists?(Rails.root.join("config/initializers/devise.rb"))
        say "Installing devise"
        generate "devise:install"
      end
      
      generate "devise AdminUser"
      
      say "you now need to run 'rake db:migrate' to create the admin_users table"
    end

  end
end
