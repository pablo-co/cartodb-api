# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cartodb/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'cartodb-api'
  spec.version       = CartoDB::Api::VERSION
  spec.authors       = ['Pablo Cárdenas']
  spec.email         = ['pcardenasoliveros@gmail.com']

  spec.summary       = %q{A wrapper for MailChimp API 3.0}
  spec.description   = %q{A wrapper for MailChimp API 3.0}
  spec.homepage      = 'https://github.com/pablo-co/cartodb-api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'

  spec.add_dependency('faraday', '>= 0.9.1')
  spec.add_dependency('multi_json', '>= 1.11.2')
end
