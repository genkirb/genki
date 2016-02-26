module Genki
  #--
  # Genki::Request
  #
  # REQUEST CLASS
  #++
  class Request < Rack::Request
    def self.current=(request)
      Thread.current[:request] = request
    end

    def self.current
      Thread.current[:request]
    end

    def json_data?
      media_type == 'application/json'
    end
  end
end
