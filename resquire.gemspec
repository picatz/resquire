# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resquire/version'

Gem::Specification.new do |spec|
  spec.name          = "resquire"
  spec.version       = Resquire::VERSION
  spec.authors       = ["Kent 'picat' Gruber"]
  spec.email         = ["kgruber1@emich.edu"]

  spec.summary       = %q{A Ruby gem dependency analysis tool to help find redundancies and increase performance.}
  spec.description   = %q{Reduce your redundant gem depenencies with resquire, which figures out which gems are redundant so you can require less gems for your ruby projects while still retaining the same functionality! By reducing redundant gems, you can make your application faster!}
  spec.homepage      = "https://github.com/picatz/resquire"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) } 
  spec.bindir        = "bin"
  spec.executable    = "resquire"  
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize"
  spec.add_dependency "lolize"
  spec.add_dependency "trollop"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
