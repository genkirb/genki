module Genki
  #--
  # Genki::Response
  #
  # RESPONSE CLASS
  #++
  class Response
    attr_accessor :body, :status, :header

    def initialize(body, status, header)
      @body = body
      @status = status
      @header = header
    end
  end
end
