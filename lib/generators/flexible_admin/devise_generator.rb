require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks

module FlexibleAdmin
  class DeviseGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "flexible_admin devise generator"
    
    def require_authentication
      if File.exists?(Rails.root.join("app/controllers/admin_controller.rb"))
        auth_code = "before_filter :authenticate_admin_user!"
        sentinel = "class AdminController < ApplicationController"
        in_root do
          inject_into_file 'app/controllers/admin_controller.rb', "\n    #{auth_code}", { :after => sentinel, :verbose => true }
        end
      end
    end
    
    def devise
      append_file "Gemfile", "\n", :force => true
      gem 'devise'
      
      inside Rails.root do
        run "bundle install"
      end        
      
      unless File.exists?(Rails.root.join("config/initializers/devise.rb"))
        say "Installing devise"
        generate "devise:install"
      end
      
      unless File.exists?(Rails.root.join("app/models/admin_user.rb"))
        generate "devise AdminUser"
        template "user_sign_in.html.erb", "app/views/admin/admin_users/sessions/new.html.erb"
        gsub_file 'config/routes.rb', "devise_for :admin_users", "devise_for :admin_users, :path_prefix => 'admin', :controllers => {:sessions => 'admin/admin_users/sessions' }"
        template "admin_user_sessions_controller.rb", "app/controllers/admin/admin_users/sessions_controller.rb"
      end
      
      say "you now need to run 'rake db:migrate' to create the admin_users table", :blue
      say "after that make your first admin_user in the console: AdminUser.create!(email: 'your_email@gmail.com', password: 'password')", :blue
    end

  end
end
