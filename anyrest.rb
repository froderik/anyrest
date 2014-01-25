require 'sinatra'
require 'json'
require 'securerandom'
require 'pry'


# globals - most importantly the hash containing all them resources

DA_STUFF = {}
KEY_SEPARATOR = '§'


# helper methods to make it easier to do stuff

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

def key_from resource, id
  "#{resource}#{KEY_SEPARATOR}#{id}"
end


# operations on a specific resource instance

get '/*/*' do |resource, id|
  key = key_from resource, id
  find_stuff( key ).to_json
end

put '/*/*' do |resource, id|
  key = key_from resource, id
  find_stuff( key )
  clean params
  DA_STUFF[key] = params
end

delete '/*/*' do |resource, id|
  key = key_from resource, id
  DA_STUFF.delete key
end


# overall operation on a resource

get '/*' do |resource|
  resources = DA_STUFF.select { |k, v| k.start_with? "#{resource}#{KEY_SEPARATOR}" }
  "#{resources.to_json}\n"
end

post '/*' do |resource|
  new_id = SecureRandom.uuid
  key = key_from resource, new_id
  clean params
  DA_STUFF[key] = params
  new_id
end

delete '/*' do |resource|
  DA_STUFF.delete_if { |k, v| k.start_with? "#{resource}#{KEY_SEPARATOR}" }
end


# the root of things

delete '/' do
  DA_STUFF = {}
end
