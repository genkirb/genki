module Genki
  class Route

    attr_reader :signature
    
    def initialize(verb, path)
      @signature = "#{verb}#{path}"
    end

  end
end