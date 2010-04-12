# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sticky_blox}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Rogers"]
  s.date = %q{2010-04-12}
  s.description = %q{see http://github.com/jacaetevha/sticky_blox for more description. I'm lazy}
  s.email = %q{jacaetevha@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc",
     "README.textile",
     "TODO"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "README.textile",
     "TODO",
     "VERSION",
     "lib/sticky_blox.rb",
     "lib/sticky_blox/behavior.rb",
     "lib/sticky_blox/proc_extension.rb",
     "spec/helper.rb",
     "spec/spearmint.rb",
     "spec/sticky_blox_spec.rb",
     "sticky_blox.gemspec"
  ]
  s.homepage = %q{http://github.com/jacaetevha/sticky_blox}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Late-binding traits for Ruby}
  s.test_files = [
    "spec/helper.rb",
     "spec/spearmint.rb",
     "spec/sticky_blox_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
  end
end

