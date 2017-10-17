require 'sinatra'
require 'wit'

require 'byebug'

require_relative 'Speech'
require_relative 'firebase_pusher'
require_relative 'logger'

API = ''
VERBOICE_URL = "http://192.168.1.102:3000"
WIT_TOKEN = ''
FIREBASE_DB_URL = 'https://testing.firebaseio.com/'

FINISHED_CALLS = ['completed', 'failed']

get '/call_finished' do
  return unless FINISHED_CALLS.include?(request.params['CallStatus'])

  speech = Speech.new(API)
  audio_url = "#{VERBOICE_URL}/calls/#{request.params['CallSid']}/results/1507648840602.wav"

  begin
    result = speech.recognize audio_url, 'vi-VN'

    wit = Wit.new(access_token: WIT_TOKEN)
    json_response = wit.message result
  rescue Exception => e
    Logger.log e.message
    return
  end

  store json_response.merge('caller' => request.params['From'], 'audio_url' => audio_url, 'reported_at' => Time.now)
end

def store json_response
  firebase_pusher = FirebasePusher.new(FIREBASE_DB_URL)
  firebase_pusher.push(json_response)
end
