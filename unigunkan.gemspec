# -*- encoding: utf-8 -*-
require File.expand_path('../lib/unigunkan/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sota Yokoe"]
  gem.email         = ["gem@kreuz45.com"]
  gem.description   = %q{Designed for Unity based projects.}
  gem.summary       = %q{A command line xcode project file modifier.}
  gem.homepage      = "http://github.com/yokoe/unigunkan"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = "unigunkan"
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "unigunkan"
  gem.require_paths = ["lib"]
  gem.version       = Unigunkan::VERSION
end
