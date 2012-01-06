module GeneratorHelpers

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
