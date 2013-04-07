$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "specifind/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "specifind"
  s.version     = Specifind::VERSION
  s.authors     = ["Max Lahey"]
  s.email       = ["maxwellslahey@gmail.com"]
  s.homepage    = "http://maxwells.github.io"
  s.summary     = "Readble & Advanced ActiveRecord dynamic methods"
  s.description = "Specifind offers advanced ActiveRecord dynamic find\_by_* methods that include comparators (like the grails ORM). Coupled with some solid SQL injection mitigation through strict verification of type and string escaping, your find methods will be much more readable. If an object of the wrong type (based on the type of the corresponding column of the db) is passed into a finder, it will raise an exception. Ruby 1.9.2 and above are supported"

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.9"

  s.add_development_dependency "sqlite3"
end
