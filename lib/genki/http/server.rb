module Genki
  #--
  # Genki::Server
  #
  # SERVER CLASS
  #++
  class Server
    def call(env)
      response = Router.instance.process(Route.new(env['REQUEST_METHOD'],
                                                   env['PATH_INFO']))

      response.finish
    end
  end
end
