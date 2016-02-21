require 'spec_helper'

describe Genki::Server do
  let(:server) { Genki::Server.new }
  let(:env) { {} }

  it 'responds with 200' do
    expect(server.call(env)[0]).to be 200
  end

  it 'responds with html' do
    expect(server.call(env)[1]).to include('Content-Type' => 'text/html')
  end

  it 'responds hello world' do
    expect(server.call(env)[2]).to eq ['Hello World!']
  end
end
