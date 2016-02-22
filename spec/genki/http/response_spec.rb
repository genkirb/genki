require 'spec_helper'

describe Genki::Response do
  let(:response) { Genki::Response.new('body', 200, 'Header' => 'Value') }

  it 'does has body' do
    expect(response.body).to eql(['body'])
  end

  it 'does has status' do
    expect(response.status).to eql(200)
  end

  it 'does has header' do
    expect(response.header).to eql('Header' => 'Value', 'Content-Length' => '4')
  end
end
