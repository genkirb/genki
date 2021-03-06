require 'genki/version'
require 'bundler'

module Genki
  module Generators
    #--
    # Genki::Generators::App
    #
    # APP GENERATOR CLASS
    #++
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
        message = set_color("Directory #{app_name} already exists", :red)
        raise Thor::Error, message if Dir.exist?(app_name) && !options[:force]
        empty_directory ''
      end

      def create_config_ru
        copy_file 'config.ru'
      end

      def create_gemfile
        template 'Gemfile'
      end

      def create_sample
        empty_directory 'app'
        template 'app/home.rb'
      end

      def run_bundle
        inside do
          Bundler.with_clean_env { run 'bundle' }
        end
      end
    end
  end
end
