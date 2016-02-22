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

    def process(route)
      @routes[route.signature].call
    end
  end
end
