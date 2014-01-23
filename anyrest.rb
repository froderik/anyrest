require 'sinatra'
require 'json'
require 'securerandom'
require 'pry'

DA_STUFF = {}

get '/:resource' do
  [].to_json  
end

get '/:resource/:id' do
  key = params[:resource] + params[:id]
  stuff = DA_STUFF[key]
  unless stuff
    raise Sinatra::NotFound
  end
  stuff.to_json
end

post '/:resource' do
  new_id = SecureRandom.uuid
  key = params[:resource] + new_id
  params.delete 'splat'
  params.delete 'resource'
  params.delete 'captures'
  DA_STUFF[key] = params
  new_id
end

delete '/:resource/:id' do
  key = params[:resource] + params[:id]
  DA_STUFF.delete key
end
