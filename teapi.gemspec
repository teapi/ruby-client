require File.expand_path('../lib/teapi/version', __FILE__)

Gem::Specification.new do |s|
  s.name               = 'teapi'
  s.description        = 'ruby client for teapi.io'
  s.homepage           = 'http://www.teapi.io'
  s.summary            = 'A ruby client for teapi.io'
  s.require_path       = 'lib'
  s.authors            = ['Karl Seguin']
  s.licenses           = ['MIT']
  s.email              = ['support@teapi.io']
  s.version            = Teapi::VERSION
  s.platform           = Gem::Platform::RUBY
  s.files              = Dir.glob("{lib}/**/*")
  s.add_dependency('httparty', '= 0.13.3')
  s.add_dependency('oj', '= 2.11.1')
end
