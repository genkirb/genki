require 'spec_helper'

describe Genki::Request do
  let(:env) { { 'REQUEST_METHOD' => :GET, 'PATH_INFO' => '/' } }
  let(:request) { Genki::Request.new(env) }

  it 'does create route' do
    expect(request.route.signature).to eql(Genki::Route.new('GET', '/').signature)
  end
end
