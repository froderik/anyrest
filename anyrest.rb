require 'sinatra'
require 'json'
require 'securerandom'

get '/:resource' do
  [].to_json  
end

post '/:resource' do
  SecureRandom.uuid
end