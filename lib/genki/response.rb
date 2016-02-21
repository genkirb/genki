module Genki
  #--
  # Genki::Response
  #
  # RESPONSE CLASS
  #++
  class Response

    attr_accessor :body, :status, :header
    
    def initialize(body, status, header)
      @body, @status, @header = body, status, header
    end
  end
  
end