# -*- encoding: utf-8 -*-

require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'shadow'
  s.version = Shadow::VERSION
  s.authors = ['Albert Yangchuanosaurus']
  s.description = 'Shadow development'
  s.license = 'MIT'
  s.email = '355592261@qq.com'
  s.executables = ['shadow']
  # s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.files = `git ls-files -z`.split("\0")
  s.homepage = 'https://github.com/yangchuanosaurus/hi-shadow'
  s.summary = 'Shadow of Zero-Solution'

  s.add_dependency('zero_logger', '~> 0')
  
  s.required_ruby_version = '>= 2.0.0'
end
