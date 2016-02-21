require "singleton"

module Genki
  class Router
    include Singleton
    
    def initialize
      @routes = {}
    end
    
    def route(route, &block)
      # TODO: check it
      @routes[route.signature] = block
    end
    
    def process(route)
      @routes[route.signature].call
    end

  end

end