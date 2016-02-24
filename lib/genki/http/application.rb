module Genki
  #--
  # Genki::Application
  #
  # APPLICATION CLASS
  #++
  class Application
    def initialize
      Dir['./app/**/*.rb'].each { |file| require file }
    end

    def call(env)
      Request.current = Request.new(env)

      response = Router.instance.process

      response.finish
    end
  end
end
