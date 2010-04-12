require "lib/sticky_blox"

Gem::Specification.new do |s|
  s.name = 'mongo'

  s.version = StickyBlox::VERSION

  s.platform = Gem::Platform::RUBY
  s.summary = 'Late-binding traits in Ruby'
  s.description = 'For more information about StickyBlox, see http://github.com/jacaetevha/sticky_blox'

  s.require_paths = ['lib']

  s.files  = ['README.textile', 'Rakefile', 'sticky_blox.gemspec', 'LICENSE']
  s.files += ['lib/sticky_blox.rb'] + Dir['lib/sticky_blox/**/*.rb']
  s.test_files = Dir['specs/**/*.rb']

  s.has_rdoc = false

  s.authors = ['Jason Rogers', 'Scott Deming']
  s.email = 'jacaetevha@gmail.com'
  s.homepage = 'http://github.com/jacaetevha/sticky_blox'
end
