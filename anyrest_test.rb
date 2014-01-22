ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), 'anyrest')

require 'minitest/autorun'
require 'rack/test'

class AnyRestTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_getting_empty_list_of_resources
    get '/stuff'
    assert last_response.ok?
    assert_equal [].to_json, last_response.body
  end
end