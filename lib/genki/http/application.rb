module Genki
  #--
  # Genki::Application
  #
  # APPLICATION CLASS
  #++
  class Application
    def call(env)
      response = Router.instance.process(Request.new(env))

      response.finish
    end
  end
end
