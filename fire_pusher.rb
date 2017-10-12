require 'firebase'

BASE_URL = 'https://epihack-vn-2017.firebaseio.com/'

def pusher location='', audio_url='', transcript='', symptoms=[], cases=0
  firebase = Firebase::Client.new(BASE_URL)
  
  # ---RAW_DATA---
  location = 'Kim Bôi, Hoà Bình'
  audio_url = ''
  transcript = 'Tôi đang ở Kim Bôi, Hoà Bình. Tôi muốn báo cáo về một trường hợp tiêu chảy cấp và sốt cao ở gần nhà tôi.'
  symptoms = ['sốt xuất huyết', 'sốt']
  cases = 4
  text = symptoms.push(cases.to_s).join(', ')

  raw_data = Hash[
    'location', "#{location}",
    'audio_url', "#{audio_url}",
    'text', text,
    'transcript', transcript
  ]

  # PUSH TO FIREBASE AND GET THE RESPONSE
  response = firebase.push("raw_data", raw_data)
  puts response.success?

  # THE KEY OF NEW DATA IN FIREBASE ARRAY
  element_key = response.raw_body
  element_key
end

pusher()
