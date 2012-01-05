class Admin::ResourcesController < AdminController
  inherit_resources
  defaults :route_prefix => 'admin'
  respond_to :html
  actions :all        
  load_and_authorize_resource
  
end
