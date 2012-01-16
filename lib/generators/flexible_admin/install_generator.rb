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
      template "navigation.html.erb", "app/views/layouts/admin/_navigation.html.erb"
      template "flash.html.erb", "app/views/layouts/admin/_flash.html.erb"
    end
    
    def create_shared_form_files
      template "forms/text_field.html.erb", "app/views/admin/shared/_text_field.html.erb"
      template "forms/text_area_field.html.erb", "app/views/admin/shared/_text_area_field.html.erb"
      template "forms/select_field.html.erb", "app/views/admin/shared/_select_field.html.erb"
      template "forms/file_field.html.erb", "app/views/admin/shared/_file_field.html.erb"
      template "forms/email_field.html.erb", "app/views/admin/shared/_email_field.html.erb"
      template "forms/cktext_area_field.html.erb", "app/views/admin/shared/_cktext_area_field.html.erb"
      template "forms/checkbox_field.html.erb", "app/views/admin/shared/_checkbox_field.html.erb"
      template "forms/error_messages.html.erb", "app/views/admin/shared/_error_messages.html.erb"
      template "forms/password_field.html.erb", "app/views/admin/shared/_password_field.html.erb"
    end
    
    def create_admin_helper
      template "admin_helper.rb", "app/helpers/admin_helper.rb"
    end
    
    def create_stylesheets
      template "stylesheets/bootstrap.sass", "app/assets/stylesheets/admin/bootstrap.sass"
      template "stylesheets/application.css", "app/assets/stylesheets/admin/application.css"
      template "stylesheets/demo_table.css", "app/assets/stylesheets/admin/datatables/demo_table.css"
      template "stylesheets/admin.sass", "app/assets/stylesheets/admin/admin.sass"
      template "images/admin-background.png", "app/assets/images/admin/admin-background.png"
    end
    
    def creates_datatables_images
      template "images/back_disabled.jpg", "app/assets/images/admin/datatables/back_disabled.jpg"
      template "images/back_enabled.jpg", "app/assets/images/admin/datatables/back_enabled.jpg"
      template "images/forward_disabled.jpg", "app/assets/images/admin/datatables/forward_disabled.jpg"
      template "images/forward_enabled.jpg", "app/assets/images/admin/datatables/forward_enabled.jpg"
      
      template "images/sort_asc.png", "app/assets/images/admin/datatables/sort_asc.png"
      template "images/sort_desc.png", "app/assets/images/admin/datatables/sort_desc.png"
      template "images/sort_both.png", "app/assets/images/admin/datatables/sort_both.png"
      template "images/sort_asc_disabled.png", "app/assets/images/admin/datatables/sort_asc_disabled.png"
      template "images/sort_desc_disabled.png", "app/assets/images/admin/datatables/sort_desc_disabled.png"
    end
    
    def creates_javascripts
      template "javascripts/application.js", "app/assets/javascripts/admin/application.js"
      template "javascripts/app.js", "app/assets/javascripts/admin/app.js"
      template "javascripts/jquery.dataTables.js", "app/assets/javascripts/admin/jquery.dataTables.js"
    end
        
    def make_admin_route
      route("get '/admin' => 'admin#index'")
    end
    
    def create_admin_controller
      template "admin_controller.rb", "app/controllers/admin_controller.rb"
    end
    
    def inherited_resources
      append_file "Gemfile", "\n", :force => true
      gem 'inherited_resources'
    end
    
    def devise
      unless defined?(Devise)
        say "Adding devise gem to your Gemfile:"
        append_file "Gemfile", "\n", :force => true
        gem 'devise'
      end
      
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
    end

  end
end
