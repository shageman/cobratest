# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'cobratest'
  spec.version       = '0.1.1'
  spec.authors       = ['Stephan Hagemann']
  spec.email         = ['stephan.hagemann@gmail.com']
  spec.summary       = %q{A test runner for your #cobra application}
  spec.description   = %q{A test runner that optimizes the tests it runs based on the recent changes of your application. Makes use of #cobra dependencies to infer which parts of the application are definitely unaffected. Science! BOOM!}
  spec.homepage      = 'https://github.com/shageman/cobradeps'
  spec.license       = 'MIT'

  spec.files         = %w(
                          bin/cobratest
                          cobratest.gemspec
                          Gemfile
                          lib/cobratest/affected_component_finder.rb
                          lib/cobratest/gemfile_scraper.rb
                          lib/cobratest/tests_to_run_selector.rb
                          lib/cobratest/transitive_affected_component_finder.rb
                          lib/cobratest.rb
                          LICENSE
                          Rakefile
                          README.md
                          )
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 1.13'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.5'
end
