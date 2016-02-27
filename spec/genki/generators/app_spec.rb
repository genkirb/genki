require 'spec_helper'
require 'support/silencer'

describe Genki::Generators::App do
  include FakeFS::SpecHelpers
  include Silencer

  APP_NAME = 'SampleApp'.freeze
  subject(:app_generator) { Genki::Generators::App.new [APP_NAME] }

  describe '.set_directory' do
    it 'sets the destination to a folder with the app name' do
      expect(app_generator).to receive(:destination_root=).with(APP_NAME)
      app_generator.set_directory
    end
  end

  describe '.create_directory' do
    before :each do
      app_generator.set_directory
    end

    it 'creates empty directory with app name' do
      app_generator.create_directory
      expect(Dir.exist?(APP_NAME)).to be_truthy
    end

    it 'does not create directory if already exists' do
      expect { 2.times { app_generator.create_directory } }.to raise_error Thor::Error
    end

    it 'does ignore directory existence if force' do
      app_generator.options = { force: true }
      expect { 2.times { app_generator.create_directory } }.to_not raise_error Thor::Error
    end
  end

  describe '.create_config_ru' do
    before :each do
      FakeFS::FileSystem.clone('lib/genki/generators/app/files')
      app_generator.set_directory
      app_generator.create_directory
    end

    it 'creates config.ru file' do
      app_generator.create_config_ru
      expect(File.exist?("#{APP_NAME}/config.ru")).to be_truthy
    end

    it 'has the right content' do
      app_generator.create_config_ru

      File.open "#{APP_NAME}/config.ru" do |file|
        content = file.read.split("\n")
        expect(content[0]).to eq 'require \'genki\''
        expect(content[1]).to eq 'app = Genki::Application.new'
        expect(content[2]).to eq 'run app'
      end
    end
  end

  describe '.create_gemfile' do
    before :each do
      FakeFS::FileSystem.clone('lib/genki/generators/app/files')
      app_generator.set_directory
      app_generator.create_directory
    end

    it 'creates Gemfile' do
      app_generator.create_gemfile
      expect(File.exist?("#{APP_NAME}/Gemfile")).to be_truthy
    end

    it 'has the right content' do
      app_generator.create_gemfile

      File.open "#{APP_NAME}/Gemfile" do |file|
        content = file.read.split("\n")
        expect(content[0]).to eq 'source \'https://rubygems.org\''
        expect(content[1]).to eq ''
        expect(content[2]).to eq "gem 'genki', '#{Genki::VERSION}'"
      end
    end
  end

  describe '.create_sample' do
    before :each do
      FakeFS::FileSystem.clone('lib/genki/generators/app/files')
      app_generator.set_directory
      app_generator.create_directory
    end

    it 'creates app folder' do
      app_generator.create_sample
      expect(Dir.exist?("#{APP_NAME}/app")).to be_truthy
    end

    it 'creates app/home.rb' do
      app_generator.create_sample
      expect(File.exist?("#{APP_NAME}/app/home.rb")).to be_truthy
    end

    it 'has the right content' do
      app_generator.create_sample

      File.open "#{APP_NAME}/app/home.rb" do |file|
        content = file.read.split("\n")
        expect(content[0]).to eq 'class Home < Genki::Controller'
        expect(content[1]).to eq ''
        expect(content[2]).to eq "  get '/' do"
        expect(content[3]).to eq "    render({ message: 'Hello World from #{APP_NAME}' })"
        expect(content[4]).to eq '  end'
        expect(content[5]).to eq 'end'
        expect(content.length).to be 6
      end
    end
  end

  describe '.run_bundle' do
    before :each do
      FakeFS::FileSystem.clone('lib/genki/generators/app/files')
      app_generator.set_directory
      app_generator.create_directory
      app_generator.create_gemfile
    end

    it 'runs bundle' do
      expect(app_generator).to receive(:run).with('bundle')
      app_generator.run_bundle
    end
  end
end
