ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), 'anyrest')

require 'minitest/autorun'
require 'rack/test'

class AnyRestTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def brew_some_beer beer_hash
    post '/beer', beer_hash
    assert last_response.ok?
    last_response.body
  end

  def teardown
    delete '/beer'
  end

  def test_getting_empty_list_of_beer
    get '/beer'
    assert last_response.ok?
    assert_equal Hash.new.to_json, last_response.body.strip
  end

  def test_posting_and_getting_some_beer
    beer_hash = { name: 'Chimay', alcohol: '12' }
    beer_id = brew_some_beer beer_hash
    assert_equal 36, beer_id.length

    get "/beer/#{beer_id}"
    assert_equal beer_hash.to_json, last_response.body
  end

  def test_raises_404_if_not_found 
    get '/beer/absent-id'
    assert_equal last_response.status, 404
  end

  def test_deletes_beer 
    beer_id = brew_some_beer style: 'belgium'
    key = "/beer/#{beer_id}"
    delete key

    get key
    assert_equal last_response.status, 404
  end

  def test_update_da_beer
    beer_hash = { name: 'Leffe Bruijn', origin: 'Holland' }
    beer_id = brew_some_beer beer_hash
    beer_hash[:origin] = 'Belgium'
    path = "/beer/#{beer_id}"
    put path, beer_hash
    get path
    assert_equal last_response.body, beer_hash.to_json
  end

  def test_getting_some_more_beer
    blask_hash = { type: 'blask', alcohol: '4' }
    brew_some_beer blask_hash
    tokyo_hash = { type: 'tokyo', alcohol: '20' }
    brew_some_beer tokyo_hash
    nanny_hash = { type: 'nanny', alcohol: '0' }
    brew_some_beer nanny_hash

    get '/beer'
    assert_equal [blask_hash, tokyo_hash, nanny_hash].to_json, last_response.body.strip
  end

end