module AdminHelper
  
  def admin_nav_item(item)
    content_tag(:li, link_to(item.humanize.titlecase, Rails.application.routes.url_helpers.send("admin_#{item}_path")), :class => active_if(controller_name == item)) if can?(:read, item.classify.constantize)
  end
  
end
