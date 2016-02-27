require 'spec_helper'

describe Genki::Logger do
  let(:logger) { Genki::Logger.instance }

  it 'does has info level' do
    expect(logger.info?).to be_truthy
  end

  describe '.info' do
    it 'does call ::Logger#info' do
      expect_any_instance_of(::Logger).to receive(:info).with('Hello')

      Genki::Logger.info('Hello')
    end
  end

  describe '.debug' do
    it 'does call ::Logger#debug' do
      expect_any_instance_of(::Logger).to receive(:debug).with('Hello')

      Genki::Logger.debug('Hello')
    end
  end

  describe '.warn' do
    it 'does call ::Logger#warn' do
      expect_any_instance_of(::Logger).to receive(:warn).with('Hello')

      Genki::Logger.warn('Hello')
    end
  end

  describe '.error' do
    it 'does call ::Logger#error' do
      expect_any_instance_of(::Logger).to receive(:error).with('Hello')

      Genki::Logger.error('Hello')
    end
  end

  describe '.fatal' do
    it 'does call ::Logger#fatal' do
      expect_any_instance_of(::Logger).to receive(:fatal).with('Hello')

      Genki::Logger.fatal('Hello')
    end
  end

  describe '.unknown' do
    it 'does call ::Logger#unknown' do
      expect_any_instance_of(::Logger).to receive(:unknown).with('Hello')

      Genki::Logger.unknown('Hello')
    end
  end
end
