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
end
