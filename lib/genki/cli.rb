require 'thor'
require 'genki/generators/app'
require 'genki/http/server'

module Genki
  #--
  # Genki::Cli
  #
  # CLI CLASS
  #++
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

    desc 'server', 'Runs Genki server'
    method_option :port, aliases: '-p', default: 3000, type: :numeric,
                         banner: 'PORT', desc: 'Run the server on the specified port.'
    method_option :binding, aliases: '-b', default: 'localhost', type: :string,
                            banner: 'IP', desc: 'The IP to listen on.'
    method_option :environment, aliases: '-e', default: 'development', type: :string,
                                banner: 'name', desc: 'Specifies with environment to run'
    def server
      opt = { Port: options['port'],
              Host: options['binding'],
              environment: options['environment'] }
      Genki::Server.new(opt).start
    end

    register Generators::App, 'new', 'new APP_NAME', 'Create a new Genki application.'
    tasks['new'].options = Generators::App.class_options
  end
end
