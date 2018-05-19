require 'sinatra'
require 'wit'

require_relative 'Speech'
require_relative 'firebase_pusher'
require_relative 'logger'
require_relative 'setting.rb'

FINISHED_CALLS = ['completed', 'failed']

# Listen on all interfaces in the development environment
set :bind, '0.0.0.0'

get '/call_finished' do
  return unless FINISHED_CALLS.include?(request.params['CallStatus'])

  speech = Speech.new(Setting.google_api_key)
  audio_url = "#{Setting.verboice_url}/calls/#{request.params['CallSid']}/results/#{Setting.verboice_first_audio_file}"

  begin
    result = speech.recognize audio_url, Setting.language_recognition

    wit = Wit.new(access_token: Setting.wit_token)
    json_response = wit.message result['transcript']
  rescue Exception => e
    Logger.log e.message
    return
  end

  store json_response.merge('caller' => request.params['From'], 'audio_url' => audio_url, 'reported_at' => Time.now)
end

def store json_response
  firebase_pusher = FirebasePusher.new(Setting.firebase_db_url)
  firebase_pusher.push(json_response)
end
