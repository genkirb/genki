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

      action = @routes[request.route.signature]
      return Response.new 'Not Found', 404 unless action
      klass = action.binding.receiver
      controller = klass.new
      controller.instance_eval(&action)
    end
  end
end
