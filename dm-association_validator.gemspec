# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-association_validator}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["roovo"]
  s.date = %q{2009-04-22}
  s.description = %q{A validator for use with associated models}
  s.email = %q{roovo@roovoweb.com}
  s.extra_rdoc_files = ["CHANGELOG", "lib/autotest/discover.rb", "lib/dm-association_validator.rb", "lib/dm-validations/association_validator.rb", "LICENSE", "README.rdoc", "tasks/spec.rb", "TODO"]
  s.files = ["CHANGELOG", "lib/autotest/discover.rb", "lib/dm-association_validator.rb", "lib/dm-validations/association_validator.rb", "LICENSE", "Rakefile", "README.rdoc", "spec/fixtures/book.rb", "spec/fixtures/borrowing.rb", "spec/fixtures/library.rb", "spec/fixtures/person.rb", "spec/integration/many_association_spec.rb", "spec/integration/singular_association_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/spec.rb", "TODO", "Manifest", "dm-association_validator.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/roovo/dm-association_validator}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Dm-association_validator", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dm-association_validator}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{A validator for use with associated models}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0"])
      s.add_runtime_dependency(%q<dm-validations>, [">= 0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0"])
      s.add_dependency(%q<dm-validations>, [">= 0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0"])
    s.add_dependency(%q<dm-validations>, [">= 0"])
  end
end
