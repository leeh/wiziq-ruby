# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wiziq/version"

Gem::Specification.new do |s|
  s.name        = "wiziq"
  s.version     = Wiziq::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lee Horrocks"]
  s.email       = ["lee@leehorrocks.com"]
  s.homepage    = ""
  s.summary     = %q{wiziq is a Ruby wrapper for the WiZiQ API}
  s.description = %q{wiziq is a Ruby gem that provides a wrapper for interacting with the WiZiQ conferencing service API.}

  s.required_rubygems_version = ">= 1.6.0"

  s.add_dependency("httpi", "0.9.1")  
  s.add_dependency("nokogiri", ">= 1.4.4")
  s.add_dependency("savon", "0.9.1")
  
  #s.add_dependency("logging", ">= 1.5.0")  
  #s.add_dependency("savon_model", ">= 0.4.1")
  
  s.add_development_dependency("bundler", "~> 1.0.0")
  s.add_development_dependency("jeweler", "~> 1.6.0")
  s.add_development_dependency("rspec", ">= 2.5.0")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("autotest-standalone", ">= 4.4.2")
  s.add_development_dependency("autotest-growl", ">= 0.2.9")
  #s.add_development_dependency("savon_spec", ">= 0.1.6")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
