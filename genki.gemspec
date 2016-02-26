# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'genki/version'

Gem::Specification.new do |s|
  s.name          = 'genki'
  s.version       = Genki::VERSION
  s.authors       = ['Diego Silva', 'Leonardo Siqueira']
  s.email         = ['diego.silva@live.com', 'leonardo.prg@gmail.com']

  s.summary       = 'A fast and minimalist framework to generate APIs in Ruby.'
  s.description   = 'Genki is a full-stack framework optimized for quick and easy creation of beautiful APIs.'
  s.homepage      = 'https://github.com/genkirb/genki'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2.2'

  s.add_dependency 'rack', '~> 2.x'
  s.add_dependency 'thor', '~> 0.19.1'
  s.add_dependency 'bundler', '~> 1.11'
  s.add_dependency 'oj', '~> 2.14.0'

  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rubocop', '~> 0.37'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'fakefs'
end
