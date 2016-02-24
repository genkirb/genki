require 'spec_helper'

describe Genki::Route do
  let(:route) do
    Genki::Route.new('/home/:id') do
    end
  end

  describe '#initialize' do
    it 'does create params' do
      expect(route.instance_variable_get('@params')).to eql([':id'])
    end

    it 'does create path' do
      expect(route.instance_variable_get('@path')).to eql('^/home/([a-z0-9])+/?$')
    end

    it 'does create action' do
      expect(route.instance_variable_get('@action')).to be_a_instance_of(Proc)
    end
  end

  describe '#match?' do
    describe 'when current path match' do
      it 'does return true' do
        expect(route.match?('/home/1')).to be_truthy
      end

      it 'does assign params to @parsed_path' do
        route.match?('/home/1')

        expect(route.instance_variable_get('@parsed_path')).to eql(['1'])
      end
    end

    describe 'when current doesnt match' do
      it 'does return false' do
        expect(route.match?('/bla')).to be_falsey
      end
    end
  end

  describe '#process' do
    before(:each) do
      Genki::Request.current = Rack::Request.new({})
      allow_any_instance_of(Rack::Request).to receive(:params).and_return('name' => 'la')
      allow_any_instance_of(RSpec::ExampleGroups::GenkiRoute::Process).to receive(:new).and_return(Genki::Controller.new)
    end

    it 'does merge params to request' do
      route.match?('/home/1')
      route.process

      expect(Genki::Request.current.params).to eql('name' => 'la', 'id' => '1')
    end

    it 'does call the route block' do
      block = double('block')

      route = Genki::Route.new('/home/:id') do
        block.run
      end

      expect(block).to receive(:run)

      route.match?('/home/1')
      route.process
    end
  end
end
