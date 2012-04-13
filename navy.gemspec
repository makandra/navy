# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "navy/version"

Gem::Specification.new do |s|
  s.name        = "navy"
  s.version     = Navy::VERSION
  s.authors     = ["Tobias Kraze", "Henning Koch"]
  s.email       = ["tobias@kraze.eu"]
  s.homepage    = ""
  s.summary     = %q{Comprehensive solution for multi-level horizontal navigation bars.}
  s.description = s.summary

  s.rubyforge_project = "navy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "actionpack"
end
