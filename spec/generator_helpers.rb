module GeneratorHelpers

  def has_route?(route)
    File.open(File.join(destination_root, 'config', 'routes.rb')).read.index(route)
  end
  
  def has_gem?(name)
    File.open(File.join(destination_root, 'Gemfile')).read.index(name)
  end
  
end
