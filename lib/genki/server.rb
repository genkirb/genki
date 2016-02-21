module Genki
  #--
  # Genki::Server
  #
  # SERVER CLASS
  #++
  class Server
    def call(env)
      Router.instance.process(Route.new(env['REQUEST_METHOD'], env['PATH_INFO']))
      [200, { 'Content-Type' => 'text/html' }, ['Hello World!']]
    end
  end
end