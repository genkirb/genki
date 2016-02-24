module Genki
  #--
  # Genki::Controller
  #
  # CONTROLLER CLASS
  #++
  class Controller
    def self.get(path, &block)
      Router.instance.route('GET', Route.new(path, &block))
    end

    def self.post(path, &block)
      Router.instance.route('POST', Route.new(path, &block))
    end

    def self.put(path, &block)
      Router.instance.route('PUT', Route.new(path, &block))
    end

    def self.delete(path, &block)
      Router.instance.route('DELETE', Route.new(path, &block))
    end

    def render(body, status = 200, header = [])
      Response.new(body, status, header)
    end

    def request
      Request.current
    end

    def params
      Request.current.params
    end
  end
end
