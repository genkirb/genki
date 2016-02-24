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
end
