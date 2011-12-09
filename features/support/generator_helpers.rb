module GeneratorHelpers
    
  def tmp_rails_app_root
    File.join(File.dirname(__FILE__), "dummy_app")
    File.expand_path("../../../tmp/aruba/dummy_app",  __FILE__)
  end
    
  def layout_exists?(filename)
    File.exists?(File.join(@app_root, "app", "views", "layouts", filename))
  end
  
  def view_exists?(filename)
    File.exists?(File.join(@app_root, "app", "views", filename))
  end
 
end
  
World(GeneratorHelpers)