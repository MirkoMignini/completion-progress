Gem::Specification.new do |s|
  s.name        = 'completion-progress'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.summary     = 'Easy progress calculator'
  s.description = s.summary
  s.email       = 'mirko.mignini@libero.it'
  s.homepage    = 'https://github.com/MirkoMignini/completion-progress'
  s.authors     = ['Mirko Mignini']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
end