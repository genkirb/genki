require 'spec_helper'

describe Genki::Controller do
  METHODS = %i(get post put delete options patch)
  let(:controller) { Genki::Controller }

  METHODS.each do |http_method|
    context "when method is #{http_method}" do
      describe ".#{http_method}" do
        let(:route) { instance_double(Genki::Route) }

        it 'does call Router.route' do
          allow(Genki::Route).to receive(:new).with('/').and_return(route).and_yield
          expect(Genki::Router.instance).to receive(:route).with(http_method.to_s.upcase, route)

          Genki::Controller.method(http_method).call('/') { }
        end

        it 'does create a correctly Route' do
          allow(Genki::Router.instance).to receive(:route)

          expect(Genki::Route).to receive(:new).with('/', any_args)

          Genki::Controller.method(http_method).call('/')
        end
      end

      describe '.namespace' do
        it 'does set namespace' do
          expect(Genki::Route).to receive(:new).with('/products/new', any_args).and_return(Genki::Route.new('/products'))

          controller.namespace '/products' do
            method(http_method).call '/new' do
            end
          end
        end

        it 'does accept nested namespace' do
          expect(Genki::Route).to receive(:new).with('/products/:id/edit', any_args).and_return(Genki::Route.new('/products/:id/edit'))

          controller.namespace '/products' do
            namespace '/:id' do
              method(http_method).call '/edit' do
              end
            end
          end
        end
      end
    end
  end

  describe '.render' do
    before :each do
      allow(Genki::Request).to receive(:current).and_return(instance_double(Genki::Request, cookies: {}))
    end

    it 'does return a Response' do
      expect(subject.render).to be_a_instance_of(Genki::Response)
    end

    describe 'response return' do
      it 'does render json body' do
        rendered = subject.render(json: { message: 'Hello' })
        expect(rendered.body).to eql(['{"message":"Hello"}'])
        expect(rendered.headers['Content-Type']).to eql('application/json')
      end

      it 'does render html body' do
        file = File.expand_path('template.html.erb', './app/views')
        allow(File).to receive(:read).with(file).and_return('<h1>Header</h1>')
        rendered = subject.render(erb: 'template.html.erb')
        expect(rendered.body).to eql(['<h1>Header</h1>'])
        expect(rendered.headers['Content-Type']).to eql('text/html')
      end

      it 'does render plain text' do
        rendered = subject.render(text: 'Hello')
        expect(rendered.body).to eql(['Hello'])
        expect(rendered.headers['Content-Type']).to eql('text/plain')
      end

      it 'does render nothing' do
        rendered = subject.render
        expect(rendered.body).to eql([''])
        expect(rendered.headers['Content-Type']).to be nil
      end

      it 'does let instance variables available for erb' do
        file = File.expand_path('template.html.erb', './app/views')
        allow(File).to receive(:read).with(file).and_return('<h1>Header</h1><p><%= @variable %></p>')

        subject.instance_variable_set('@variable', 'value')
        expect(subject.render(erb: 'template.html.erb').body).to eql(['<h1>Header</h1><p>value</p>'])
      end

      it 'does not change instance variables outside erb' do
        file = File.expand_path('template.html.erb', './app/views')
        allow(File).to receive(:read).with(file).and_return('<h1>Header</h1><p><%= @variable = "value2" %></p>')

        subject.instance_variable_set('@variable', 'value')
        expect(subject.render(erb: 'template.html.erb').body).to eql(['<h1>Header</h1><p>value2</p>'])
        expect(subject.instance_variable_get('@variable')).to eq 'value'
      end

      it 'does has default status ' do
        expect(subject.render(json: { message: 'Hello' }).status).to eql(200)
      end

      it 'does has default header ' do
        expect(subject.render(json: { message: 'Hello' }).header).to eql('content-type' => 'application/json', 'Content-Length' => '19')
      end

      it 'does has correctly status ' do
        expect(subject.render(json: { message: 'Hello' }, status: 403).status).to eql(403)
      end

      it 'does has correctly header ' do
        expect(subject.render(json: { message: 'Hello' }, status: 200, headers: { 'Header' => 'Value' }).header)
          .to eql('Header' => 'Value', 'content-type' => 'application/json', 'Content-Length' => '19')
      end

      it 'does add cookies to the response' do
        subject.cookies['key2'] = 'value2'
        expect(subject.render(json: { message: 'Hello' }).set_cookie_header).to eq 'key2=value2'
      end

      it 'does not add unchanged from request cookies to the response' do
        allow(Genki::Request).to receive(:current).and_return(Genki::Request.new 'HTTP_COOKIE' => 'key=value')
        subject.cookies['key2'] = 'value2'
        expect(subject.render(json: { message: 'Hello' }).set_cookie_header).to eq 'key2=value2'
      end

      it 'does add changed cookies from request to response' do
        allow(Genki::Request).to receive(:current).and_return(Genki::Request.new 'HTTP_COOKIE' => 'key=value')
        subject.cookies['key'] = 'new_value'
        subject.cookies['key2'] = 'value2'
        expect(subject.render(json: { message: 'Hello' }).set_cookie_header).to eq "key=new_value\nkey2=value2"
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
    let(:request) { instance_double(Rack::Request) }

    it 'does return params' do
      allow(Genki::Request).to receive(:current).and_return(request)
      allow(request).to receive(:params).and_return(id: 1)

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
