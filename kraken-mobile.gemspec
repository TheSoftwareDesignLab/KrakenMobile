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
  s.homepage    = 'https://github.com/TheSoftwareDesignLab/KrakenMobile'
  s.required_ruby_version = '>= 2.2.0'
  s.summary     = %q{Automated E2E mobile testing involving intercommunication scenarios. }
  s.description = %q{Automated E2E testing involving intercommunication between two or more mobile applications running in different devices or emulators. }
  s.executables   = 'kraken-mobile'
  s.files        = lambda do
      Dir.glob('lib/**/*') +
      Dir.glob("bin/**/*.rb") +
      Dir.glob("calabash-android-features-skeleton/**/*.*") +
      Dir.glob("reporter/**/*.*") +
      ["bin/kraken-mobile"] +
      %w(LICENSE README.md)
  end.call

  s.add_dependency( 'cucumber', '~> 3.1')
  s.add_dependency( 'calabash-android', '0.9.8')
  s.add_dependency( 'parallel', '1.14.0')
  s.add_dependency( 'tty-prompt', '0.18.1')
  s.add_development_dependency 'byebug', '~> 11.1'
  s.add_dependency( 'capybara', '3.31.0')
  s.add_dependency( 'selenium-webdriver', '3.14.0')
  s.add_dependency( 'faker', '2.10.0')

  s.require_paths = ['lib']
end
