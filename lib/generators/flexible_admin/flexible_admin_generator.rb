require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks

module FlexibleAdmin
  class FlexibleAdminGenerator < Rails::Generators::Base
    namespace "flexible_admin"
    source_root File.expand_path("../templates", __FILE__)
    argument :model_name, :type => :string, :required => true, :desc => "Model name for admin section generation"

    desc "flexible_admin resource generator, rails g flexible_admin Post"
        
    def creates_resource_views
      template "resources/index.html.erb", "app/views/admin/#{resources_name}/index.html.erb"
      template "resources/new.html.erb", "app/views/admin/#{resources_name}/new.html.erb"
      template "resources/edit.html.erb", "app/views/admin/#{resources_name}/edit.html.erb"
      template "resources/form.html.erb", "app/views/admin/#{resources_name}/_form.html.erb"
    end
    
    def remove_any_namespace_admin_comments_in_routes
      gsub_file 'config/routes.rb', /#\s*(namespace :admin do)/, ''
    end
    
    def make_routes
      if has_admin_route_namespace?
        routing_code = "
    resources :#{resources_name}, :except => :show do
      member do
        get 'toggle'
      end
    end"
        sentinel = /namespace :admin do$/
        in_root do
          inject_into_file 'config/routes.rb', "\n          #{routing_code}", { :after => sentinel, :verbose => true }
        end
      else
        route_info = "
    namespace :admin do
      resources :#{resources_name}, :except => :show do
        member do
          get 'toggle'
        end
      end
    end"
        route(route_info)
      end
    end
    
    def create_resources_controller
      template "admin_resources_controller.rb", "app/controllers/admin/resources_controller.rb"
      template "resources_controller.rb", "app/controllers/admin/#{resources_name}_controller.rb"
    end
    
    def add_to_navigation_menu
      gsub_file 'app/views/layouts/admin/_navigation.html.erb', "models = %w(", "models = %w(#{resources_name} "
    end    
    
    private
        
      def model
        singular_name.classify.constantize
      end
    
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
      
      def table_column_headers
        model_title = ["<th>#{model_title(model)}</th>"]
        other_columns = table_column_names_for(model).collect{|column_name| "<th>#{column_name.titleize}</th>" }
        (model_title + other_columns).join("\n      ")
      end
      
      def model_title(model)
        attributes = model.column_names
        if attributes.include?("title")
          "Title"
        elsif attributes.include?("name")
          "Name"
        else
          "#{model.name} ID"
        end
      end
      
      def table_rows
        model_title_value = "<td><%= link_to #{model_title_value(model)}, edit_admin_#{singular_name}_path(#{singular_name}) %></td>"
        other_columns = table_columns_for(model).collect do |column| 
          if column.name =~ /_file_name/
            column_name = column.name.split("_file_name").first
            if is_image?(column_name)
              "<td><%= image_tag(#{singular_name}.#{column_name}.url, :width => 24, :height => 24) %></td>"
            else
              "<td><%= link_to #{singular_name}.#{column_name}.original_filename, #{singular_name}.#{column_name}.url %></td>"
            end
          elsif column.type == :datetime
            "<td><%= #{singular_name}.#{column.name}.strftime(\"%F %T\") %></td>"
          elsif column.type == :boolean
            "<td><%= toggle(#{singular_name}, :#{column.name}) %></td>"
          else
            "<td><%= #{singular_name}.#{column.name} %></td>"
          end
        end
        ([model_title_value] + other_columns).join("\n      ")
      end
      
      def model_title_value(model)
        attributes = model.column_names
        if attributes.include?("title")
          "#{singular_name}.title"
        elsif attributes.include?("name")
          "#{singular_name}.name"
        else
          "#{singular_name}.id"
        end
      end
      
      def columns_for(model)
        rejections = %w( ^id$ _type$ type created_at created_on updated_at updated_on deleted_at reset_password_token reset_password_sent_at sign_in _content_type file_size).join("|")
        model.columns.reject { |f| f.name.match(rejections) }
      end
            
      def table_columns_for(model)
        rejections = %w( ^id$ _type$ type password remember ^name$ ^title$ created_on updated_at updated_on deleted_at reset_password_token reset_password_sent_at sign_in _content_type file_size).join("|")
        desired_columns = model.columns.reject { |f| f.name.match(rejections) }
      end
      
      def table_column_names_for(model)
        table_columns_for(model).collect { |c| c.name =~ /_file_name/ ? c.name.split("_file_name").first : c.name }
      end
      
      def render_form_fields(model)
        columns_for(model).collect do |column|
          if column.type == :string && column.name =~ /_file_name/
            column_name = column.name.split("_file_name").first
            "<%= render 'admin/shared/file_field', :f => f, :what => :#{column_name} %>"
          elsif column.type == :string && column.name =~ /encrypted_password/
            "<%= render 'admin/shared/text_field', :f => f, :what => :password %>"
          elsif column.type == :string && column.name =~ /email/
            "<%= render 'admin/shared/email_field', :f => f, :what => :#{column.name} %>"
          elsif column.type == :boolean
            "<%= render 'admin/shared/checkbox_field', :f => f, :what => :#{column.name} %>"
          elsif column.type == :text
            if column.name =~ /(body|description)/
              "<%= render 'admin/shared/cktext_area_field', :f => f, :what => :#{column.name} %>"
            else
              "<%= render 'admin/shared/text_area_field', :f => f, :what => :#{column.name} %>"
            end
          else
            "<%= render 'admin/shared/text_field', :f => f, :what => :#{column.name} %>"
          end
        end.join("\n")

      end
      
      
      def has_admin_route_namespace?
        File.open(File.join(destination_root, 'config', 'routes.rb')).read.index("namespace :admin do")
      end
      
      def is_image?(text)
        text =~ /(img|image|avatar|pic|logo)/
      end
            
  end
end
