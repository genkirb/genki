require 'bundler/setup'

module Genki
  #--
  # Genki::Application
  #
  # APPLICATION CLASS
  #++
  class Application
    def initialize
      Bundler.require(:default, Genki.env)
      Dir['./app/**/*.rb'].each { |file| require file }
    end

    def call(env)
      Request.current = Request.new(env)

      response = Router.instance.process
    rescue RouteNotFoundError
      response = Response.new('', 404)
    rescue StandardError => e
      Logger.error(e)
      response = Response.new('', 500)
    ensure
      response.finish
    end
  end
end
