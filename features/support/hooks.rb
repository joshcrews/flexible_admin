Before do
  @aruba_timeout_seconds = 10
end

Before do
  @app_root = tmp_rails_app_root  
end
 
After do
  FileUtils.rm_rf(tmp_rails_app_root)
end
