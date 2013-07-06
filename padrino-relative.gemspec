version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |gem|
  gem.name        = 'padrino-relative'
  gem.version     = version
  gem.date        = '2012-09-22'
  gem.summary     = 'Relative controller paths in Padrino'
  gem.description = 'Enables relative controller paths in Padrino (for DRYness)'
  gem.authors     = ['Kyle Lacy']
  gem.email       = 'kylelacy@me.com'
  gem.files       = ['lib/padrino-relative.rb']
  gem.homepage    = 'http://github.com/kylewlacy/timerizer'

  gem.add_dependency('padrino')
end
