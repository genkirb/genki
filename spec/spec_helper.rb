require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'fakefs/spec_helpers'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'genki'
