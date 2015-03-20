lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dml/repository/version'

Gem::Specification.new do |spec|
  spec.name          = 'dml-repository'
  spec.version       = Dml::Repository::VERSION::String
  spec.authors       = ['Andrey Savchenko', 'Denis Sergienko', 'Alexey Dashkevich']
  spec.email         = ['andrey@aejis.eu', 'denis@aejis.eu', 'jester@aejis.eu']
  spec.summary       = %q{DB Repository}
  spec.description   = %q{Repository pattern for database manipulation layer}
  spec.homepage      = 'https://github.com/Aejis/dml-repository'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.test_files    = Dir['spec/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
end
