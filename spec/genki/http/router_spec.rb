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

    it 'raises error when associating same route twice' do
      router.route 'GET', Genki::Route.new('/twice')
      expect { router.route 'GET', Genki::Route.new('/twice') }
        .to raise_error(Genki::RouteAlreadyDefinedError, "Trying to redefine already defined route 'GET /twice'.")
    end
  end

  describe '#process' do
    let(:request) { Genki::Request.new('REQUEST_METHOD' => 'POST', 'PATH_INFO' => '/') }
    let(:invalid_request) { Genki::Request.new('REQUEST_METHOD' => 'PUT', 'PATH_INFO' => '/hello') }

    it 'does call process on the route' do
      router.route 'POST', route
      Genki::Request.current = request
      expect(route).to receive(:process)

      router.process
    end

    context 'when invalid request' do
      before :each do
        Genki::Request.current = invalid_request
      end

      it 'does raise RouteNotFoundError when route not found' do
        expect do
          router.process
        end.to raise_error(Genki::RouteNotFoundError)
      end
    end
  end
end
