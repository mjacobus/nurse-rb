$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['COVERALLS']
  require 'coveralls'
  Coveralls.wear!
end

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    add_filter '/test/'
  end
end

if ENV['SCRUTINIZER']
  require 'scrutinizer/ocular'
  Scrutinizer::Ocular.watch!
end

require 'nurse'
require 'minitest/autorun'
require 'minitest/reporters'

ENV.delete('VIM')
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
