require 'sinatra'
require 'wit'

require 'byebug'

require_relative 'Speech'
require_relative 'firebase_pusher'

API = 'AIzaSyCH6lu4WD2i4NXNbOPD8n6exAZYx0e6G8U'
VERBOICE_URL = "http://192.168.1.119:3000"
WIT_TOKEN = 'JTWEOP64NNA7IPHXWXSYQTI5IAQPFFTV'
FIREBASE_DB_URL = 'https://epihack-vn-2017.firebaseio.com/'

get '/call_finished' do
  return unless request.params['CallStatus'] == 'completed'

  speech = Speech.new(API)
  audio_url = "#{VERBOICE_URL}/calls/#{request.params['CallSid']}/results/1507648840602.wav"
  result = speech.recognize audio_url, 'vi-VN'

  wit = Wit.new(access_token: WIT_TOKEN)
  json_response = wit.message result

  store json_response.merge('caller' => request.params['From'], 'audio_url' => audio_url, 'reported_at' => Time.now)
end

def store json_response
  firebase_pusher = FirebasePusher.new(FIREBASE_DB_URL)
  firebase_pusher.push(json_response)
end
