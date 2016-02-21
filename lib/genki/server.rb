module Genki
  #--
  # Genki::Server
  #
  # SERVER CLASS
  #++
  class Server
    def call(_env)
      [200, { 'Content-Type' => 'text/html' }, ['Hello World!']]
    end
  end
end
