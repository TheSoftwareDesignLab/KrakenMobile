# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'kraken-mobile/version'

Gem::Specification.new do |s|
  s.name        = 'kraken-mobile'
  s.version     = KrakenMobile::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['William Ravelo M']
  s.email       = ['drummerwilliam@gmail.com']
  s.homepage    = 'https://github.com/ravelinx22'
  s.summary     = %q{Automated E2E mobile testing involving intercommunication scenarios. }
  s.description = %q{Automated E2E testing involving intercommunication between two or more mobile applications running in different devices or emulators. }
  s.executables   = 'kraken-mobile'
  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)

  s.add_dependency( 'calabash-android', '0.9.8')
  s.add_dependency( 'parallel', '1.14.0')

  s.require_paths = ['lib']
end
