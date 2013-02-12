# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eva/version'

Gem::Specification.new do |gem|
  gem.name          = 'eva'
  gem.version       = Eva::VERSION
  gem.authors       = ['DAddYE']
  gem.email         = ['info@daddye.it']
  gem.summary       = 'Effortless event driven micro framework with a tasty syntax'
  gem.description   = gem.summary
  gem.homepage      = 'https://github.com/DAddYE/eva'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'eventmachine', '~>1.0.0'
end
