require 'thor'
require_relative 'generators/app'

module Genki
  class Cli < Thor
    include Thor::Actions

    check_unknown_options!

    def self.exit_on_failure?
      true
    end

    desc 'version', 'Display Genki version'
    map %w(-v --version) => :version
    def version
      say "Genki #{Genki::VERSION}"
    end

    register Generators::App, 'new', 'new APP_NAME', 'Create a new Genki application.'
    tasks['new'].options = Generators::App.class_options
  end
end
