require 'spec_helper'

describe Genki::Request do
  describe '.current=' do
    it 'does put request on thread' do
      Genki::Request.current = 1

      expect(Genki::Request.current).to eql(1)
    end
  end

  describe '.current' do
    it 'does return thread request' do
      Genki::Request.current = 10

      expect(Genki::Request.current).to eql(10)
    end
  end

  describe '.json_data?' do
    let(:request) { Genki::Request.new({}) }

    it 'does return a boolean' do
      expect(request.json_data?).to be false
    end

    it 'does return true when content-type == json' do
      request.env['CONTENT_TYPE'] = 'application/json; charset=UTF-8'
    end
  end
end
