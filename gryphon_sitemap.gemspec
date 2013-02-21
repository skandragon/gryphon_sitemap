require File.expand_path('../lib/gryphon_sitemap/version', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "gryphon_sitemap"
  gem.version     = GryphonSitemap::VERSION
  gem.authors     = ["Michael Graff"]
  gem.email       = ["explorer@flame.org"]
  gem.homepage    = "http://github.com/skandragon/gryphon_sitemap"
  gem.summary     = "Simple sitemaps for rails."
  gem.description = "Add simple sitemap support to models, and use generic or custom templates to render them."
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  gem.test_files = Dir["spec/**/*"]

  gem.add_dependency 'activerecord', '~> 3.2.0'

  gem.add_development_dependency 'rails', '~> 3.2.0'
  gem.add_development_dependency 'rspec-rails', '~> 2.9.0'
  if RUBY_PLATFORM =~ /java/
    gem.add_development_dependency 'activerecord-jdbcpostgresql-adapter'
  else
    gem.add_development_dependency 'pg'
  end
  unless ENV['CI']
    if RUBY_PLATFORM =~ /java/
      gem.add_development_dependency 'ruby-debug'
    elsif RUBY_VERSION == '1.9.3'
      gem.add_development_dependency 'debugger', '~> 1.1.2'
    end
  end
end
