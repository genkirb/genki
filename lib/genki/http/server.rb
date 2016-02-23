require 'rack'

module Genki
  #--
  # Genki::Server
  #
  # SERVER CLASS
  #++
  class Server < Rack::Server
    def initialize(options = {})
      options = default_options.merge(options)
      super
    end

    def start
      uri = "http://#{options[:Host]}:#{options[:Port]}"
      puts "Genki application starting in #{options[:environment]} on #{uri}"
      super
    end
  end
end
