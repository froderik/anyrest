ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), 'anyrest')

require 'minitest/autorun'
require 'rack/test'

class AnyRestTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_getting_empty_list_of_beer
    get '/beer'
    assert last_response.ok?
    assert_equal [].to_json, last_response.body
  end

  def test_posting_some_beer
    post '/beer', name: 'Chimay Red', alcohol: '12'
    assert last_response.ok?
    assert_equal 36, last_response.body.length
  end
end