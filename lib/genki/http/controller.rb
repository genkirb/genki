module Genki
  #--
  # Genki::Controller
  #
  # CONTROLLER CLASS
  #++
  class Controller
    def self.get(path, &block)
      Router.instance.route(Route.new(:GET, path), &block)
    end

    def self.post(path, &block)
      Router.instance.route(Route.new(:POST, path), &block)
    end

    def self.put(path, &block)
      Router.instance.route(Route.new(:PUT, path), &block)
    end

    def self.delete(path, &block)
      Router.instance.route(Route.new(:DELETE, path), &block)
    end

    def render(body, status = 200, header = [])
      Response.new(body, status, header)
    end

    def request
      Thread.current[:request]
    end

    def params
      request.params
    end
  end
end
