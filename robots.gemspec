# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{robots}
  s.version = "0.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kyle Maxwell"]
  s.date = %q{2011-04-12}
  s.description = %q{It parses robots.txt files}
  s.email = %q{kyle@kylemaxwell.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG",
     "README",
     "Rakefile",
     "VERSION",
     "lib/robots.rb",
     "robots.gemspec",
     "test/fixtures/emptyish.txt",
     "test/fixtures/eventbrite.txt",
     "test/fixtures/google.txt",
     "test/fixtures/reddit.txt",
     "test/fixtures/yelp.txt",
     "test/test_robots.rb"
  ]
  s.homepage = %q{http://github.com/fizx/robots}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Simple robots.txt parser}
  s.test_files = [
    "test/test_robots.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end

