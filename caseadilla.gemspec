# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caseadilla/version'

Gem::Specification.new do |spec|
  spec.name          = "caseadilla"
  spec.version       = Caseadilla::VERSION
  spec.authors       = ["Xavier Bick"]
  spec.email         = ["fxb9500@gmail.com"]
  spec.description   = "Caseadilla is a CMS for Rails based on Casein and Comfortable Mexican Sofa. It is designed to allow you to easily fit the CMS to your app, not the other way around.  By default, Caseadilla installs with Devise for authentication and Declarative Authorization, however it can be installed without either if you want to use an existing auth system."
  spec.summary       = "A powerful yet unobtrusive CMS and data management system for Rails."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  if spec.respond_to? :specification_version then
    spec.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      spec.add_runtime_dependency(%q<caseadilla>, [">= 0"])
      spec.add_runtime_dependency(%q<will_paginate>, ["= 3.0.5"])
      spec.add_runtime_dependency(%q<devise>, [">= 3.2"])
      spec.add_runtime_dependency(%q<declarative_authorization>, [">= 0.5.7"])
      spec.add_runtime_dependency(%q<scrypt>, ["= 1.2.1"])
      spec.add_runtime_dependency(%q<jquery-rails>, [">= 0"])
      spec.add_runtime_dependency(%q<best_in_place>, [">= 0"])
    else
      spec.add_dependency(%q<caseadilla>, [">= 0"])
      spec.add_dependency(%q<will_paginate>, ["= 3.0.5"])
      spec.add_dependency(%q<devise>, [">= 3.2"])
      spec.add_dependency(%q<declarative_authorization>, [">= 0.5.7"])
      spec.add_dependency(%q<scrypt>, ["= 1.2.1"])
      spec.add_dependency(%q<jquery-rails>, [">= 0"])
      spec.add_dependency(%q<best_in_place>, [">= 0"])
    end
  else
    spec.add_dependency(%q<caseadilla>, [">= 0"])
    spec.add_dependency(%q<will_paginate>, ["= 3.0.5"])
    spec.add_dependency(%q<devise>, ["= 3.2"])
    spec.add_dependency(%q<declarative_authorization>, [">= 0.5.7"])
    spec.add_dependency(%q<scrypt>, ["= 1.2.1"])
    spec.add_dependency(%q<jquery-rails>, [">= 0"])
    spec.add_dependency(%q<best_in_place>, [">= 0"])
  end
end