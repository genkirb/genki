require 'logger'
require 'singleton'

module Genki
  #--
  # Genki::Logger
  #
  # Logger class
  #++
  class Logger < ::Logger
    include Singleton

    def initialize
      super(STDOUT, ::Logger::INFO)
    end

    class << self
      ::Logger::Severity.constants.each do |level|
        define_method(level.downcase) { |msg| Logger.instance.method(level.downcase).call(msg) }
      end
    end
  end
end
