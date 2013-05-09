# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dotmation"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Prince"]
  s.date = "2013-05-09"
  s.description = "TODO: longer description of your gem"
  s.email = "jtprince@gmail.com"
  s.executables = ["dotmation"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/dotmation",
    "dotmation.gemspec",
    "lib/dotmation.rb",
    "lib/dotmation/config_reader.rb",
    "lib/dotmation/repo.rb",
    "script/bootstrap-ruby-env.sh",
    "spec/dotmation/repo_spec.rb",
    "spec/dotmation_spec.rb",
    "spec/spec_helper.rb",
    "spec/testfiles/config"
  ]
  s.homepage = "http://github.com/jtprince/dotmation"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.0"
  s.summary = "TODO: one-line summary of your gem"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.13.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3.5"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.13.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.0.0"])
      s.add_dependency(%q<bundler>, ["~> 1.3.5"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.13.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.0.0"])
    s.add_dependency(%q<bundler>, ["~> 1.3.5"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
  end
end

