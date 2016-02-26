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

    def render(body, status = 200, header = {})
      header['content-type'] ||= 'application/json'

      response = Response.new(JSON.dump(body), status, header)
      cookies.each do |key, value|
        response.set_cookie(key, value) if cookie_changed?(key, value)
      end
      response
    end

    def request
      Request.current
    end

    def params
      Request.current.params
    end

    def cookies
      @_cookies ||= request.cookies.dup
    end

    private

    def cookie_changed?(key, value)
      request.cookies[key] != value
    end
  end
end
