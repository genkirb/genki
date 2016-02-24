require 'spec_helper'

describe Genki::Router do
  let(:router) { Genki::Router.instance }
  let(:route) { Genki::Route.new('/') {} }

  it 'does has @routes' do
    expect(router.instance_variable_get('@routes')).to eql({})
  end

  describe '#route' do
    let(:routes) { router.instance_variable_get('@routes') }

    it 'does associate a block to signature' do
      router.route 'GET', route

      expect(routes['GET']).to include(route)
    end
  end

  describe '#process' do
    let(:request) { Genki::Request.new('REQUEST_METHOD' => 'POST', 'PATH_INFO' => '/') }
    let(:invalid_request) { Genki::Request.new('REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello') }

    before :each do
      router.route 'POST', route
    end

    it 'does call process on the route' do
      Genki::Request.current = request
      expect(route).to receive(:process)

      router.process
    end

    context 'when invalid request' do
      before :each do
        Genki::Request.current = invalid_request
      end

      it 'does not try to process when route not found' do
        expect_any_instance_of(Genki::Route).to_not receive(:process)
        expect { router.process }.to_not raise_error
      end

      it 'does return 404 when route not found' do
        response = router.process
        expect(response.status).to eq 404
      end
    end
  end
end
