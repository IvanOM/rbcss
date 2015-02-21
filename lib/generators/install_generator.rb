require 'rails/generators'
module Rbcss
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../install/templates', __FILE__)

      desc 'Install rbcss assets engine'
      
      def add_rbcss_initializer
        path = "#{::Rails.root}/config/initializers/sprockets.rb"
        if File.exist?(path)
          puts 'Skipping config/initializers/sprockets.rb creation, file already exists!'
        else
          puts 'Adding rbcss initializer (config/initializers/sprockets.rb)...'
          template 'sprockets.rb', path
        end
      end
    end
  end
end