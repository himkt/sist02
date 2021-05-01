# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sist02/version'

Gem::Specification.new do |spec|
  spec.name          = "sist02"
  spec.version       = Sist02::VERSION
  spec.authors       = ["Makoto Hiramatsu"]
  spec.email         = ["himkt@klis.tsukuba.ac.jp"]

  spec.summary       = %q{easy way to make sist02 formed reference}
  spec.description   = %q{make reference via web api}
  spec.homepage      = "https://github.com/himkt/sist02"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
