require 'spec_helper'

describe Genki::Controller do
  let(:controller) { Genki::Controller }

  describe '#get' do
    it 'does call Router.route' do
      expect(Genki::Router.instance).to receive(:route).with('GET', any_args)

      Genki::Controller.get('/')
    end

    it 'does create a correctly Route' do
      allow(Genki::Router.instance).to receive(:route)

      expect(Genki::Route).to receive(:new).with('/', any_args)

      Genki::Controller.get('/')
    end
  end

  describe '#post' do
    it 'does call Router.route' do
      expect(Genki::Router.instance).to receive(:route).with('POST', any_args)

      Genki::Controller.post('/')
    end

    it 'does create a correctly Route' do
      allow(Genki::Router.instance).to receive(:route)

      expect(Genki::Route).to receive(:new).with('/', any_args)

      Genki::Controller.post('/')
    end
  end

  describe '#put' do
    it 'does call Router.route' do
      expect(Genki::Router.instance).to receive(:route).with('PUT', any_args)

      Genki::Controller.put('/')
    end

    it 'does create a correctly Route' do
      allow(Genki::Router.instance).to receive(:route)

      expect(Genki::Route).to receive(:new).with('/', any_args)

      Genki::Controller.put('/')
    end
  end

  describe '#delete' do
    it 'does call Router.route' do
      expect(Genki::Router.instance).to receive(:route).with('DELETE', any_args)

      Genki::Controller.delete('/')
    end

    it 'does create a correctly Route' do
      allow(Genki::Router.instance).to receive(:route)

      expect(Genki::Route).to receive(:new).with('/', any_args)

      Genki::Controller.delete('/')
    end
  end

  describe '.render' do
    before :each do
      allow(Genki::Request).to receive(:current).and_return(instance_double(Genki::Request, cookies: {}))
    end

    it 'does return a Response' do
      expect(subject.render('Hello')).to be_a_instance_of(Genki::Response)
    end

    describe 'response return' do
      it 'does has correctly body ' do
        expect(subject.render('Hello').body).to eql(['"Hello"'])
      end

      it 'does has default status ' do
        expect(subject.render('Hello').status).to eql(200)
      end

      it 'does has default header ' do
        expect(subject.render('Hello').header).to eql('content-type' => 'application/json', 'Content-Length' => '7')
      end

      it 'does has correctly status ' do
        expect(subject.render('Hello', 403).status).to eql(403)
      end

      it 'does has correctly header ' do
        expect(subject.render('Hello', 200, 'Header' => 'Value').header)
          .to eql('Header' => 'Value', 'content-type' => 'application/json', 'Content-Length' => '7')
      end

      it 'does add cookies to the response' do
        subject.cookies['key2'] = 'value2'
        expect(subject.render('Hello').set_cookie_header).to eq 'key2=value2'
      end

      it 'does not add unchanged from request cookies to the response' do
        Genki::Request.current = Genki::Request.new 'HTTP_COOKIE' => 'key=value'
        subject.cookies['key2'] = 'value2'
        expect(subject.render('Hello').set_cookie_header).to eq 'key2=value2'
      end

      it 'does add changed cookies from request to response' do
        Genki::Request.current = Genki::Request.new 'HTTP_COOKIE' => 'key=value'
        subject.cookies['key'] = 'new_value'
        subject.cookies['key2'] = 'value2'
        expect(subject.render('Hello').set_cookie_header).to eq "key=new_value\nkey2=value2"
      end
    end
  end

  describe '.request' do
    it 'does call thread current' do
      expect(Genki::Request).to receive(:current)

      subject.request
    end
  end

  describe '.params' do
    it 'does return params' do
      allow(Genki::Request).to receive(:current).and_return(Rack::Request)
      allow(Rack::Request).to receive(:params).and_return(id: 1)

      expect(subject.params).to eql(id: 1)
    end
  end

  describe '.cookies' do
    before :each do
      Genki::Request.current = Genki::Request.new 'HTTP_COOKIE' => 'key=value'
    end

    it 'does set instance variable' do
      expect(subject.instance_variable_get('@_cookies')).to be_nil
      subject.cookies
      expect(subject.instance_variable_get('@_cookies')).to eq Genki::Request.current.cookies
    end

    it 'does retrive request cookies' do
      expect(subject.cookies).to eq('key' => 'value')
    end

    it 'does store a new cookie' do
      subject.cookies['key2'] = 'value2'
      expect(subject.cookies).to include('key' => 'value')
      expect(subject.cookies).to include('key2' => 'value2')
    end
  end
end
