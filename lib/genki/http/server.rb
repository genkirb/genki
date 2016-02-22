module Genki
  #--
  # Genki::Server
  #
  # SERVER CLASS
  #++
  class Server
    def call(env)
      response = Router.instance.process(Request.new(env))

      response.finish
    end
  end
end
