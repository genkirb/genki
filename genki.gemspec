# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'genki/version'

Gem::Specification.new do |s|
  s.name          = 'genki'
  s.version       = Genki::VERSION
  s.authors       = ['Diego Silva', 'Leonardo Siqueira']
  s.email         = ['diego.silva@live.com', 'leonardo.prg@gmail.com']

  s.summary       = 'TODO: Write a short summary, because Rubygems requires one.'
  s.description   = 'TODO: Write a longer description or delete this line.'
  s.homepage      = "TODO: Put your gem's website or public repo URL here."
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'rack', '~> 2.x'

  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rubocop', '~> 0.37'
end
