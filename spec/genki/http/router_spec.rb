require 'spec_helper'

describe Genki::Router do
  let(:router) { Genki::Router.instance }
  let(:route) { Genki::Route.new('GET', '/') }

  it 'does has @routes' do
    expect(router.instance_variable_get('@routes')).to eql({})
  end

  describe '#route' do
    let(:routes) { router.instance_variable_get('@routes') }

    it 'does associate a block to signature' do
      router.route route do
      end

      expect(routes['GET/']).to be_a_instance_of(Proc)
    end
  end

  describe '#process' do
    let(:request) { Genki::Request.new('REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/') }
    let(:invalid_request) { Genki::Request.new('REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello') }
    let(:routes) { router.instance_variable_get('@routes') }

    it 'does call block with correctly signature' do
      router.route route do
      end

      expect(routes['GET/']).to receive(:call)

      router.process(request)
    end

    it 'does put request on Thread' do
      router.route route do
      end

      router.process(request)

      expect(Thread.current[:request]).to eql(request)
    end

    it 'does not try to call block when route not found' do
      expect { router.process(invalid_request) }.to_not raise_error
    end

    it 'does return 404 when route not found' do
      response = router.process(invalid_request)
      expect(response.status).to eq 404
    end
  end
end
