require 'sinatra'

require "google/cloud/speech"
require 'rest-client'
require 'base64'
require 'json'

require_relative 'Speech'

require 'byebug'

API = ''
VERBOICE_URL = "http://192.168.1.108:3000"

get '/call_finished' do
  speech = Speech.new(API)
  audio_url = "#{VERBOICE_URL}/calls/#{request.params['CallSid']}/results/1507648840602.wav"
  result = speech.recognize audio_url, 'vi-VN'
  store result
end

def store result
  # TODO
end
