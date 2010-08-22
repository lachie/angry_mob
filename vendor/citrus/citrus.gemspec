Gem::Specification.new do |s|
  s.name = 'citrus'
  s.version = '1.5.1'
  s.date = '2010-08-17'

  s.summary = 'Parsing Expressions for Ruby'
  s.description = 'Parsing Expressions for Ruby'

  s.author = 'Michael Jackson'
  s.email = 'mjijackson@gmail.com'

  s.require_paths = %w< lib >

  s.files = Dir['benchmark/**'] +
    Dir['doc/**'] +
    Dir['examples/**'] +
    Dir['extras/**'] +
    Dir['lib/**/*.rb'] +
    Dir['test/**/*'] +
    %w< citrus.gemspec Rakefile README >

  s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/ }

  s.add_dependency('builder')
  s.add_development_dependency('rake')

  s.has_rdoc = true
  s.rdoc_options = %w< --line-numbers --inline-source --title Citrus --main Citrus >
  s.extra_rdoc_files = %w< README >

  s.homepage = 'http://mjijackson.com/citrus'
end
