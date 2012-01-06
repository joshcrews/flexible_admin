require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks

module FlexibleAdmin
  class ResourceGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    argument :model_name, :type => :string, :required => true, :desc => "Model name for admin section generation"

    desc "flexible_admin resource generator"
        
    def creates_resource_views
      template "resources/index.html.erb", "app/views/admin/#{resources_name}/index.html.erb"
      template "resources/new.html.erb", "app/views/admin/#{resources_name}/new.html.erb"
      template "resources/edit.html.erb", "app/views/admin/#{resources_name}/edit.html.erb"
      template "resources/form.html.erb", "app/views/admin/#{resources_name}/_form.html.erb"
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
    end
    
    def remove_any_namespace_admin_comments_in_routes
      gsub_file 'config/routes.rb', /#\s*(namespace :admin do)/, ''
    end
    
    def make_routes
      if has_admin_route_namespace?
        routing_code = "resources :#{resources_name}"
        sentinel = /namespace :admin do$/
        in_root do
          inject_into_file 'config/routes.rb', "\n          #{routing_code}", { :after => sentinel, :verbose => true }
        end
      else
        route_info = "
        namespace :admin do
          resources :#{resources_name}
        end"
        route(route_info)
      end
    end
    
    def create_resources_controller
      template "admin_resources_controller.rb", "app/controllers/admin/resources_controller.rb"
      template "resources_controller.rb", "app/controllers/admin/#{resources_name}_controller.rb"
    end
    
    
    private
    
      def resources_name
        model_name.tableize
      end
      
      def singular_name
        resources_name.singularize
      end
      
      def instance_variable_resource
        "@#{resources_name.singularize}"
      end
      
      def upper_case_resources_name
        upper_case_resource_name.pluralize
      end
      
      def upper_case_resource_name
        resources_name.classify.pluralize
      end
      
      def has_admin_route_namespace?
        File.open(File.join(destination_root, 'config', 'routes.rb')).read.index("namespace :admin do")
      end


  end
end
