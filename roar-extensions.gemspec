# -*- encoding: utf-8 -*-
require File.expand_path('../lib/roar_extensions/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Donald Plummer", "Michael Xavier"]
  gem.email         = ["developers@crystalcommerce.com"]
  gem.description   = %q{Useful extensions to roar}
  gem.summary       = %q{Useful extensions to roar}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "roar-extensions"
  gem.require_paths = ["lib"]
  gem.version       = RoarExtensions::VERSION

  gem.add_dependency("roar", "~>0.11.2")
  gem.add_dependency("active_support", ">= 2.3.14")

  gem.add_development_dependency("rake", "~>0.9.2")
  gem.add_development_dependency("rspec", "~>2.10.0")
  gem.add_development_dependency("guard", "~>1.2.1")
  gem.add_development_dependency("guard-rspec", "~>1.1.0")
end
