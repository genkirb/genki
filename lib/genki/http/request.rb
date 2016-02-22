module Genki
  #--
  # Genki::Request
  #
  # REQUEST CLASS
  #++
  class Request < Rack::Request
    attr_reader :route

    def initialize(env)
      super(env)
      @route = Route.new(env['REQUEST_METHOD'], env['PATH_INFO'])
    end
  end
end
