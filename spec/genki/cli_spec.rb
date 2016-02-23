require 'spec_helper'
require 'support/capture'
require 'support/silencer'

describe Genki::Cli do
  include Silencer

  describe '#start' do
    subject(:invalid_call) { Genki::Cli.start ['invalid'] }

    it 'exits on error' do
      expect { invalid_call }.to raise_error SystemExit
    end

    it 'exits with status code 1 when error' do
      begin
        invalid_call
      rescue SystemExit => e
        expect(e.status).to be 1
      end
    end
  end

  describe '.new' do
    it 'requires an argument' do
      expect { subject.new }.to raise_error Thor::RequiredArgumentMissingError
    end

    it 'calls the Genki::Generators::App' do
      expect_any_instance_of(Genki::Generators::App).to receive(:invoke_all).and_return(nil)
      subject.new 'SampleApp'
    end
  end

  describe '.version' do
    let(:output) { capture(:stdout) { subject.version } }

    it 'returns the version' do
      expect(output).to match "Genki #{Genki::VERSION}"
    end

    it 'returns the same as -v' do
      expect(capture(:stdout) { Genki::Cli.start ['-v'] }).to eq output
    end

    it 'returns the same as --version' do
      expect(capture(:stdout) { Genki::Cli.start ['--version'] }).to eq output
    end
  end

  describe '.server' do
    let(:server_double) { instance_double(Genki::Server, start: nil) }

    it 'invokes start on Genki::Server' do
      expect_any_instance_of(Genki::Server).to receive(:start)
      subject.server
    end

    it 'passes the short options to Genki::Server' do
      expect(Genki::Server).to receive(:new).with(Port: 1234, Host: '0.0.0.0', environment: 'test').and_return(server_double)
      Genki::Cli.start %w(server -p=1234 -b=0.0.0.0 -e=test)
    end
    it 'passes the short options to Genki::Server' do
      expect(Genki::Server).to receive(:new).with(Port: 1234, Host: '0.0.0.0', environment: 'test').and_return(server_double)
      Genki::Cli.start %w(server --port=1234 --binding=0.0.0.0 --environment=test)
    end
  end
end
