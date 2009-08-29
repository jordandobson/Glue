# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{glue}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jordan Dobson"]
  s.date = %q{2009-08-25}
  s.default_executable = %q{glue}
  s.description = %q{Enables posting to GlueNow.com API service and reading posts from Glue accounts.}
  s.email = ["jordan.dobson@madebysquad.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/glue.rb", "test/test_glue.rb"]
  s.homepage = %q{http://glue.rubyforge.org}
  s.post_install_message = %q{Get ready to Glue!}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{glue}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Enables posting to GlueNow.com API service and reading posts from Glue accounts.}
  s.test_files = ["test/test_glue.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 1.12.2"])
    else
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.12.2"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.12.2"])
  end
end