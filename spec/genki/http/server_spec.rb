require 'spec_helper'
require 'support/capture'
require 'support/silencer'

describe Genki::Server do
  include Silencer

  describe '#new' do
    it 'accepts an options hash and merge with default options' do
      options = { opt1: :val1, opt2: :val2, Port: 1234 }
      server = Genki::Server.new options
      expect(server.options).to include options
      expect(server.options).to eq(subject.default_options.merge(options))
    end
  end

  describe '.start' do
    let(:output) { capture(:stdout) { subject.start } }

    it 'calls Rack::Server start (super)' do
      expect_any_instance_of(Rack::Server).to receive(:start)
      subject.start
    end

    it 'outputs the starting server phrase' do
      allow_any_instance_of(Rack::Server).to receive(:start)
      options = { environment: 'test', Host: '0.0.0.0', Port: 1234 }
      subject.options = options
      expect(output).to match("Genki application starting in #{options[:environment]} on http://#{options[:Host]}:#{options[:Port]}")
    end
  end
end
