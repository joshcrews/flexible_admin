require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks

module FlexibleAdmin
  class ResourceGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    argument :model_name, :type => :string, :required => true, :desc => "Model name for admin section generation"

    desc "flexible_admin resource generator"
        
    def creates_index_view
      template "resources_index.html.erb", "app/views/admin/#{resources_name}/index.html.erb"
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
      
      def upper_case_resources_name
        resources_name.classify.pluralize
      end
      
      def has_admin_route_namespace?
        File.open(File.join(destination_root, 'config', 'routes.rb')).read.index("namespace :admin do")
      end


  end
end
