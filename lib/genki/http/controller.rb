require 'json'

module Genki
  #--
  # Genki::Controller
  #
  # CONTROLLER CLASS
  #++
  class Controller
    def self.namespace(path, &block)
      @namespace ||= []
      @namespace << path

      instance_eval(&block)

      @namespace = nil
    end

    def self.get(path, &block)
      Router.instance.route('GET', Route.new((@namespace || []).push(path).join, &block))
    end

    def self.post(path, &block)
      Router.instance.route('POST', Route.new((@namespace || []).push(path).join, &block))
    end

    def self.put(path, &block)
      Router.instance.route('PUT', Route.new((@namespace || []).push(path).join, &block))
    end

    def self.delete(path, &block)
      Router.instance.route('DELETE', Route.new((@namespace || []).push(path).join, &block))
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
