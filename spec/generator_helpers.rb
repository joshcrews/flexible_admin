module GeneratorHelpers
  
  def copy_over_admin_navigation_that_install_generator_would_put_in
    admin_layout_dir = ::File.path(destination_root + '/app/views/layouts/admin/')
    FileUtils.mkpath admin_layout_dir
    FileUtils.cp(::File.expand_path("../../lib/generators/flexible_admin/templates/navigation.html.erb", __FILE__), ::File.path(destination_root + '/app/views/layouts/admin/_navigation.html.erb'))
  end
  
  def copy_over_admin_controller_that_install_generator_would_put_in
    FileUtils.cp(::File.expand_path("../../lib/generators/flexible_admin/templates/admin_controller.rb", __FILE__), ::File.path(destination_root + '/app/controllers/admin_controller.rb'))
  end

  def has_route?(route)
    File.open(File.join(destination_root, 'config', 'routes.rb')).read.index(route)
  end
  
  def has_gem?(name)
    File.open(File.join(destination_root, 'Gemfile')).read.index(name)
  end
  
  def dummy_app_file(file_name)
    File.open(File.join(destination_root, file_name))
  end
  
end
