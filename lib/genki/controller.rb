module Genki
  #--
  # Genki::Controller
  #
  # CONTROLLER CLASS
  #++
  class Controller

    def self.get(path, &block)
      Router.instance.route(Route.new(:GET, path), &block)
    end
  end
  
end