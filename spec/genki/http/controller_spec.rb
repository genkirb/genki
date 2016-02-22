require 'spec_helper'

describe Genki::Controller do
  let(:controller) { Genki::Controller }

  describe '.get' do
    it 'does call Router.route' do
      expect(Genki::Router.instance).to receive(:route)

      Genki::Controller.get('/')
    end

    it 'does create a correctly Route' do
      allow(Genki::Router.instance).to receive(:route)

      expect(Genki::Route).to receive(:new).with(:GET, '/')

      Genki::Controller.get('/')
    end
  end

  describe '.post' do
    it 'does call Router.route' do
      expect(Genki::Router.instance).to receive(:route)

      Genki::Controller.post('/')
    end

    it 'does create a correctly Route' do
      allow(Genki::Router.instance).to receive(:route)

      expect(Genki::Route).to receive(:new).with(:POST, '/')

      Genki::Controller.post('/')
    end
  end

  describe '.put' do
    it 'does call Router.route' do
      expect(Genki::Router.instance).to receive(:route)

      Genki::Controller.put('/')
    end

    it 'does create a correctly Route' do
      allow(Genki::Router.instance).to receive(:route)

      expect(Genki::Route).to receive(:new).with(:PUT, '/')

      Genki::Controller.put('/')
    end
  end

  describe '.delete' do
    it 'does call Router.route' do
      expect(Genki::Router.instance).to receive(:route)

      Genki::Controller.delete('/')
    end

    it 'does create a correctly Route' do
      allow(Genki::Router.instance).to receive(:route)

      expect(Genki::Route).to receive(:new).with(:DELETE, '/')

      Genki::Controller.delete('/')
    end
  end

  describe '.render' do
    it 'does return a Response' do
      expect(Genki::Controller.render('Hello')).to be_a_instance_of(Genki::Response)
    end

    describe 'response return' do
      it 'does has correctly body ' do
        expect(Genki::Controller.render('Hello').body).to eql(['Hello'])
      end

      it 'does has default status ' do
        expect(Genki::Controller.render('Hello').status).to eql(200)
      end

      it 'does has default header ' do
        expect(Genki::Controller.render('Hello').header).to eql('Content-Length' => '5')
      end

      it 'does has correctly status ' do
        expect(Genki::Controller.render('Hello', 403).status).to eql(403)
      end

      it 'does has correctly header ' do
        expect(Genki::Controller.render('Hello', 200, 'Header' => 'Value').header)
          .to eql('Header' => 'Value', 'Content-Length' => '5')
      end
    end
  end
end
