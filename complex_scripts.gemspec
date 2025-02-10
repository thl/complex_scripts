$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "complex_scripts/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "complex_scripts"
  s.version     = ComplexScripts::VERSION
  s.authors     = ["Andres Montano"]
  s.email       = ["amontano@virginia.edu"]
  s.homepage    = "http://subjects.kmaps.virginia.edu"
  s.summary     = "complex_scripts extends the Ruby's String class to provide additional methods for the proper display of complex scripts. Additionally, it also provides helper methods to be used within views."
  s.description = "complex_scripts extends the Ruby's String class to provide additional methods for the proper display of complex scripts. Additionally, it also provides helper methods to be used within views."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails'
  s.add_development_dependency 'rspec-rails'
  #s.add_dependency 'hpricot' #, '>= 0.8.6'
  
  # s.add_dependency "jquery-rails"
end
