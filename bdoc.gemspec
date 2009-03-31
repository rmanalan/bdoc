# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bdoc}
  s.version = "0.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rich Manalang"]
  s.date = %q{2009-03-30}
  s.default_executable = %q{bdoc}
  s.description = %q{Bdoc is a simple replacement for gem server that doesn't require running a server and is much nicer to browse.}
  s.email = ["rich.manalang@gmail.com"]
  s.executables = ["bdoc"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc","lib/bdoc.rb"]
  s.files = ["bin/bdoc", "History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/bdoc.rb", "templates/index.html", "templates/jquery.js", "templates/screen.css", "test/test_bdoc.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = "http://github.com/manalang/bdoc/tree/master"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{bdoc}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Bdoc is a simple replacement for gem server.  All it does is look at all of the Gems you have installed locally and creates a nice iframe based browser that makes it easy to navigate between gem docs. IT DOES NOT REQUIRE A SERVER FOR VIEWING... not like gem server does!}
  s.test_files = ["test/test_bdoc.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<launchy>, [">= 0.3.3"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.3"])
      s.add_development_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<launchy>, [">= 0.3.3"])
      s.add_dependency(%q<json>, [">= 1.1.3"])
      s.add_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<launchy>, [">= 0.3.3"])
    s.add_dependency(%q<json>, [">= 1.1.3"])
    s.add_dependency(%q<newgem>, [">= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
