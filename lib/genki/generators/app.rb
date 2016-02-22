module Genki
  module Generators
    class App < Thor::Group
      include Thor::Actions

      argument :app_name
      class_option :force, aliases: '-f', default: false, type: :boolean

      def self.source_root
        File.expand_path('../app/files', __FILE__)
      end

      def set_directory
        self.destination_root = app_name
      end

      def create_directory
        raise Thor::Error, set_color("Directory #{app_name} already exists", :red) if Dir.exist?(app_name) && !options[:force]
        empty_directory ''
      end

      def create_config_ru
        copy_file 'config.ru'
      end
    end
  end
end
