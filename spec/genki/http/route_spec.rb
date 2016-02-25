require 'spec_helper'

describe Genki::Route do
  let(:route) do
    Genki::Route.new('/companies/:company_id/employees/:id') do
    end
  end

  describe '#initialize' do
    it 'does create params' do
      expect(route.instance_variable_get('@params')).to eql([':company_id', ':id'])
    end

    it 'does create path' do
      expect(route.instance_variable_get('@path')).to eql('^/companies/([a-z0-9])+/employees/([a-z0-9])+/?$')
    end

    it 'does create action' do
      expect(route.instance_variable_get('@action')).to be_a_instance_of(Proc)
    end
  end

  describe '#match?' do
    describe 'when current path match' do
      it 'does return true' do
        expect(route.match?('/companies/1/employees/2')).to be_truthy
      end

      it 'does assign params to @parsed_path' do
        route.match?('/companies/1/employees/2')

        expect(route.instance_variable_get('@parsed_path')).to eql(%w(1 2))
      end
    end

    describe 'when current doesnt match' do
      it 'does return false' do
        expect(route.match?('/bla')).to be_falsey
      end
    end
  end

  describe '#process' do
    let(:genki_controller) { Genki::Controller.new }

    before(:each) do
      Genki::Request.current = Rack::Request.new({})
      allow_any_instance_of(Rack::Request).to receive(:params).and_return('name' => 'la')
      allow_any_instance_of(RSpec::ExampleGroups::GenkiRoute::Process).to receive(:new).and_return(genki_controller)
    end

    it 'does merge params to request' do
      route.match?('/companies/1/employees/2')
      route.process

      expect(Genki::Request.current.params).to eql('name' => 'la', 'company_id' => '1', 'id' => '2')
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

    it 'does call the block whitin the controller context' do
      expect(genki_controller).to receive(:instance_eval)

      route.match?('/companies/1/employees/2')
      route.process
    end
  end
end
