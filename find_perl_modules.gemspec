# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'find_perl_modules/version'

Gem::Specification.new do |gem|
  gem.name          = "find_perl_modules"
  gem.version       = FindPerlModules::VERSION
  gem.authors       = ["Robert Boone"]
  gem.email         = ["robert@cpanel.net"]
  gem.description   = %q{Find new perl modules and email about the one's we watch for}
  gem.summary       = %q{Find perl modules from RSS Feed}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
