require 'rack'
require 'genki/version'
require 'genki/utils/logger'
require 'genki/cli'
require 'genki/errors/route_already_defined_error'
require 'genki/errors/route_not_found_error'
require 'genki/http/application'
require 'genki/http/router'
require 'genki/http/route'
require 'genki/http/controller'
require 'genki/http/request'
require 'genki/http/response'
require 'genki/http/server'

module Genki
  class << self
    attr_accessor :env
  end
end
