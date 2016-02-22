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

    rack_response = server.call(env)
    expect(rack_response[0]).to eql(200)
    expect(rack_response[1]).to eql('Content-Length' => '11')
    expect(rack_response[2].body).to eql(['Hello World'])
  end

  it 'does create Request with env info' do
    allow(Genki::Router.instance).to receive(:process).and_return(response)
    expect(Genki::Request).to receive(:new).with(env)

    server.call(env)
  end
end
