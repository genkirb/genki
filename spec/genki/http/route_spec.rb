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
      expect(route.instance_variable_get('@path')).to eql('^/companies/([a-z0-9]+)/employees/([a-z0-9]+)/?$')
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
        route.match?('/companies/123/employees/2')

        expect(route.instance_variable_get('@parsed_path')).to eql(%w(123 2))
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
      Genki::Request.current = Genki::Request.new({})
      allow(Genki::Request.current).to receive(:params).and_return('name' => 'la')
      allow(self).to receive(:new).and_return(Genki::Controller.new)
    end

    it 'does call process_params' do
      expect(route).to receive(:process_params)

      route.match?('/home/1')
      route.process
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

  describe '#process_params' do
    before(:each) do
      Genki::Request.current = Genki::Request.new({})
      allow(Genki::Request.current).to receive(:params).and_return('name' => 'la')
    end

    it 'does merge URL params to request' do
      route.match?('/companies/1/employees/2')
      route.send(:process_params)

      expect(Genki::Request.current.params).to eql('name' => 'la', 'company_id' => '1', 'id' => '2')
    end

    context 'when receiving JSON data' do
      JSON_DATA = '{"json":{"id":1, "bool":true, "string":"lala", "sub_obj":{"id":5}}}'.freeze

      before :each do
        env = { 'CONTENT_TYPE' => 'application/json', 'rack.input' => instance_double(StringIO, read: JSON_DATA) }
        Genki::Request.current = Genki::Request.new(env)

        route.match?('/companies/1/employees/2')
        route.send(:process_params)
      end

      it 'does parse JSON parameters' do
        expect(Genki::Request.current.params).to include JSON.parse(JSON_DATA)
      end

      it 'does merge JSON with URL params' do
        expect(Genki::Request.current.params).to eql({ 'company_id' => '1', 'id' => '2' }.merge(JSON.parse(JSON_DATA)))
      end

      it 'does get correct object types and values' do
        expect(Genki::Request.current.params['json']['id']).to be 1
        expect(Genki::Request.current.params['json']['bool']).to be true
        expect(Genki::Request.current.params['json']['string']).to eql 'lala'.freeze
        expect(Genki::Request.current.params['json']['sub_obj']).to eql 'id' => 5
        expect(Genki::Request.current.params['json']['sub_obj']['id']).to be 5
      end
    end
  end
end
