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

  def test_posting_and_getting_some_beer
    beer_hash = { name: 'Chimay Red', alcohol: '12' }
    post '/beer', beer_hash
    assert last_response.ok?
    beer_id = last_response.body
    assert_equal 36, beer_id.length

    get "/beer/#{beer_id}"
    assert_equal beer_hash.to_json, last_response.body
  end

  def test_raises_404_if_not_found 
    get '/beer/absent-id'
    assert_equal last_response.status, 404
  end

end