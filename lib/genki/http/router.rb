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

    def route(method, route)
      @routes[method] ||= []
      @routes[method] << route
    end

    def process
      current_route = nil

      if @routes[Request.current.request_method]
        @routes[Request.current.request_method].each do |route|
          current_route = route.match?(Request.current.path) ? route : nil
          break if current_route
        end
      end

      raise RouteNotFoundError unless current_route

      current_route.process
    end
  end
end
