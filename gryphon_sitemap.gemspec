$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gryphon_sitemap/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gryphon_sitemap"
  s.version     = GryphonSitemap::VERSION
  s.authors     = ["Michael Graff"]
  s.email       = ["explorer@flame.org"]
  s.homepage    = "http://github.com/skandragon/gryphon_sitemap"
  s.summary     = "Simple sitemaps for rails."
  s.description = "Add simple sitemap support to models, and use generic or custom templates to render them."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"

  s.add_development_dependency "pg"
end
