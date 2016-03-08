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

    def self.options(path, &block)
      Router.instance.route('OPTIONS', Route.new((@namespace || []).push(path).join, &block))
    end

    def self.patch(path, &block)
      Router.instance.route('PATCH', Route.new((@namespace || []).push(path).join, &block))
    end

    def render(json: nil, erb: nil, text: nil, headers: {}, status: 200)
      body = render_json(json, headers) || render_erb(erb, headers) || render_text(text, headers) || ''

      response = Response.new(body, status, headers)
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

    def render_json(json, headers)
      return if json.nil?

      headers['content-type'] ||= 'application/json'
      JSON.dump(json)
    end

    def render_erb(view, headers)
      return if view.nil?

      require 'erubis'
      file = File.expand_path(view, './app/views')
      headers['content-type'] ||= 'text/html'

      context = instance_variables.map { |var| [var[1..-1], instance_variable_get(var)] }.to_h

      Erubis::Eruby.new(File.read(file)).evaluate(context)
    end

    def render_text(text, headers)
      return if text.nil?

      headers['content-type'] ||= 'text/plain'
      text
    end

    def cookie_changed?(key, value)
      request.cookies[key] != value
    end
  end
end
