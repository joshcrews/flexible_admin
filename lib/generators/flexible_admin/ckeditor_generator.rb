require 'rails/generators'

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks

module FlexibleAdmin
  class CkeditorGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "flexible_admin ckeditor generator"
    
    def install_gem
      append_file "Gemfile", "\n", :force => true
      gem "ckeditor", "~> 3.7.0.rc2"
      
      inside Rails.root do
        run "bundle install"
      end
    end
    
    def run_generator
      generate "ckeditor:install --orm=active_record --backend=paperclip"      
    end
    
    def set_paperclip_settings_for_s3
      remove_file 'app/models/ckeditor/picture.rb'
      remove_file 'app/models/ckeditor/attachment_file.rb'
      template "ckeditor/picture.rb", "app/models/ckeditor/picture.rb"
      template "ckeditor/attachment_file.rb", "app/models/ckeditor/attachment_file.rb"
    end
    
    def instructions
      say "you now need to run 'rake db:migrate' to create the ckeditor tables", :blue
      say "the pictures/attachments for ckeditor assume an amazon_s3 config file at config/amazon_s3.yml.  Add that file OR change the settings at app/models/ckeditor/picture.rb & app/models/ckeditor/attachment_file.rb", :blue
    end

  end
end
