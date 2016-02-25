module Genki
  #--
  # Genki::Route
  #
  # ROUTE CLASS
  #++
  class Route
    def initialize(path, &block)
      @params   = path.scan(/:[a-z_]+/)
      @path     = '^'.concat(path.gsub(/:[a-z_]+/, '([a-z0-9])+')).concat('/?$')
      @action   = block
    end

    def match?(current_path)
      @parsed_path = current_path.match(@path).to_a[1..-1]
    end

    def process
      params = {}

      @params.each_with_index do |param, index|
        params[param[1..-1]] = @parsed_path[index]
      end

      Request.current.params.merge!(params)

      klass = @action.binding.receiver
      controller = klass.new
      controller.instance_eval(&@action)
    end
  end
end
