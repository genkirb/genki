module Genki
  #--
  # Genki::Server
  #
  # SERVER CLASS
  #++
  class Server
    def call(env)
      response = Router.instance.process(Route.new(env['REQUEST_METHOD'], env['PATH_INFO']))

      [response.status, response.header, [response.body]]
    end
  end
end