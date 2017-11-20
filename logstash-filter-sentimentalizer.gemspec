Gem::Specification.new do |s|
  s.name          = 'logstash-filter-sentimentalizer'
  s.version       = '0.2.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'This plugin will analyze sentiment of a specified field.'
  s.description   = 'A logstash plugin to derive sentiment from fields.'
  s.authors       = ['Tyler Langlois']
  s.email         = 'tyler@elastic.co'
  s.homepage      = 'https://github.com/tylerjl/logstash-filter-sentimentalizer'
  s.require_paths = ['lib']

  # Files
  s.files = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { 'logstash_plugin' => 'true', 'logstash_group' => 'filter' }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-codec-plain', '~> 3.0'
  s.add_runtime_dependency 'logstash-core-plugin-api', '~> 2.0'
  s.add_runtime_dependency 'sentimentalizer', '~> 0.3.0'

  s.add_development_dependency 'logstash-devutils', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
end
