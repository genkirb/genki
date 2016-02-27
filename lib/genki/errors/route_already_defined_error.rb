module Genki
  #--
  # Genki::RouteAlreadyDefinedError
  #
  # RouteAlreadyDefinedError class
  #++
  class RouteAlreadyDefinedError < StandardError
    def initialize(route)
      super("Trying to redefine already defined route '#{route}'.")
    end
  end
end
