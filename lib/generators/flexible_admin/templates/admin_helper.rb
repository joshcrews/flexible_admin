module AdminHelper
  
  def admin_nav_item(item)
    content_tag(:li, link_to(item.humanize.titlecase, Rails.application.routes.url_helpers.send("admin_#{item}_path")), :class => active_if(controller_name == item)) if can?(:read, item.classify.constantize)
  end
  
  def help_text_present?(all_variables)
    all_variables.include?(:help)
  end
  
  def toggle(resource, attribute)
    if resource.send(attribute)
      link_to "True", toggle_admin_path(resource, attribute)
    else
      link_to "False", toggle_admin_path(resource, attribute)
    end
  end
  
  private
  
    def toggle_admin_path(resource, field)
      url_for(:controller => "admin/#{resource.class.tableize}", :action => "toggle", :id => resource.id, :field => field)
    end
  
end
