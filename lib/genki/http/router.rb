require 'singleton'

module Genki
  #--
  # Genki::Route
  #
  # ROUTER CLASS
  #++
  class Router
    include Singleton

    def initialize
      @routes = {}
    end

    def route(route, &block)
      @routes[route.signature] = block
    end

    def process(request)
      Thread.current[:request] = request
      @routes[request.route.signature].call
    end
  end
end
