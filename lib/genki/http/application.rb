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
      response = Router.instance.process(Request.new(env))

      response.finish
    end
  end
end
