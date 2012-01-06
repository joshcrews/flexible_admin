class AdminController < ApplicationController
  # before_filter :authenticate_admin_user!
  layout 'admin/base'
  
  def index
  end
  
  def toggle
    @resource = resource
    @resource.toggle(params[:field])
    @resource.save
    redirect_to :back, :notice => "#{resource.class.to_s} successfully updated"
  end  
      
  private
    def resource
      params[:controller].extract_class
    end
    # helper_method :resource

end
