require 'spec_helper'

describe Genki::Server do
  let(:server) { Genki::Server.new }
  let(:env) { { 'REQUEST_METHOD' => :GET, 'PATH_INFO' => '/' } }
  let(:response) { Genki::Response.new('Hello World', 200, []) }

  it 'does call Router.process' do
    expect(Genki::Router.instance).to receive(:process).and_return(response)

    server.call(env)
  end

  it 'does return response' do
    allow(Genki::Router.instance).to receive(:process).and_return(response)

    expect(server.call(env)).to eql([200, [], ['Hello World']])
  end

  it 'does create Route with env info' do
    allow(Genki::Router.instance).to receive(:process).and_return(response)
    expect(Genki::Route).to receive(:new).with(env['REQUEST_METHOD'], env['PATH_INFO'])

    server.call(env)
  end
end
