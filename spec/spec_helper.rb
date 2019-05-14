require 'simplecov'
require 'rack/test'
require 'json'

SimpleCov.start do
  add_filter '/spec/'
end

require 'rest_base'
Dir[File.dirname(__FILE__) + '/fixtures/**/*.rb'].each {|file| require file }

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() RestBase::Test::TestApplication end
end

RSpec.configure do |conf|
  conf.include RSpecMixin
end