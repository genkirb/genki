require 'spec_helper'

describe Genki::Application do
  let(:application) { Genki::Application.new }
  let(:env) { { 'REQUEST_METHOD' => :GET, 'PATH_INFO' => '/' } }
  let(:response) { Genki::Response.new('Hello World', 200, []) }

  before :all do
    Genki.env = 'test'
  end

  before :each do
    Genki::Request.current = nil
  end

  it 'does call Bundler.require' do
    expect(Bundler).to receive(:require).with(:default, 'test')
    application
  end

  it 'does call require on files inside ./app' do
    files = ['./app/home.rb', './app/site.rb']
    expect(Dir).to receive(:[]).and_return(files)
    expect_any_instance_of(Genki::Application).to receive(:require).with(files[0])
    expect_any_instance_of(Genki::Application).to receive(:require).with(files[1])
    application
  end

  it 'does call Router.process' do
    expect(Genki::Router.instance).to receive(:process).and_return(response)

    application.call(env)
  end

  it 'does return response' do
    allow(Genki::Router.instance).to receive(:process).and_return(response)

    rack_response = application.call(env)

    expect(rack_response.status).to eql(200)
    expect(rack_response.header).to eql('Content-Length' => '11')
    expect(rack_response.body).to eql(['Hello World'])
  end

  it 'does create Request with env info' do
    allow(Genki::Router.instance).to receive(:process).and_return(response)
    expect(Genki::Request).to receive(:new).with(env)

    application.call(env)
  end

  it 'does set current request' do
    allow(Genki::Router.instance).to receive(:process).and_return(response)

    expect(Genki::Request.current).to be_nil
    application.call(env)
    expect(Genki::Request.current).to_not be_nil
  end

  it 'does rescue RouteNotFoundError' do
    allow(Genki::Router.instance).to receive(:process).and_raise(Genki::RouteNotFoundError)

    response = application.call(env)
    expect(response.status).to eql(404)
  end

  it 'does rescue general Errors' do
    allow(Genki::Router.instance).to receive(:process).and_raise(ZeroDivisionError)

    response = application.call(env)
    expect(response.status).to eql(500)
  end
end
