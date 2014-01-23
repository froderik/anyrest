require 'sinatra'
require 'json'
require 'securerandom'
require 'pry'

DA_STUFF = {}

def find_stuff key
  stuff = DA_STUFF[key]
  raise Sinatra::NotFound unless stuff
  stuff
end

def clean params
  params.delete 'splat'
  params.delete 'resource'
  params.delete 'captures'
  params.delete 'id'
end

get '/:resource' do
  [].to_json  
end

get '/:resource/:id' do
  key = params[:resource] + params[:id]
  find_stuff( key ).to_json
end

post '/:resource' do
  new_id = SecureRandom.uuid
  key = params[:resource] + new_id
  clean params
  DA_STUFF[key] = params
  new_id
end

put '/:resource/:id' do
  key = params[:resource] + params[:id]
  find_stuff( key )
  clean params
  DA_STUFF[key] = params
end

delete '/:resource/:id' do
  key = params[:resource] + params[:id]
  DA_STUFF.delete key
end
