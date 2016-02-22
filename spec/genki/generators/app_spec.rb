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
      app_generator.set_directory
      app_generator.create_directory
      FakeFS::FileSystem.clone('lib/genki/generators/app/files')
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
        expect(content[1]).to eq 'app = Genki::Server.new'
        expect(content[2]).to eq 'run app'
      end
    end
  end
end
