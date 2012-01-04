module GeneratorHelpers

  def has_route?(route)
    File.open(File.join(destination_root, 'config', 'routes.rb')).read.index(route)
  end
  
end
