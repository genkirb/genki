require 'spec_helper'

describe Genki::Route do

  let(:route) { Genki::Route.new(:GET, '/') }

  it 'does has signature' do
    expect(route.signature).to eql("GET/")
  end

end
