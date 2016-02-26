require 'oj'

module Genki
  #--
  # Genki::Route
  #
  # ROUTE CLASS
  #++
  class Route
    def initialize(path, &block)
      @params   = path.match(/:[a-z]+/).to_a
      @path     = '^'.concat(path.gsub(/:[a-z]+/, '([a-z0-9])+')).concat('/?$')
      @action   = block
    end

    def match?(current_path)
      @parsed_path = current_path.match(@path).to_a[1..-1]
    end

    def process
      process_params

      klass = @action.binding.receiver
      controller = klass.new
      controller.instance_eval(&@action)
    end

    private

    def process_params
      params = {}

      @params.each_with_index do |param, index|
        params[param[1..-1]] = @parsed_path[index]
      end

      if Request.current.json_data?
        raw_data = Request.current.env['rack.input'].read
        params.merge!(Oj.load(raw_data))
      end

      Request.current.params.merge!(params)
    end
  end
end
