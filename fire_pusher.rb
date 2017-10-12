require 'firebase'

BASE_URL = 'https://epihack-vn-2017.firebaseio.com/'

def pusher response_from_wit
  raw_data = response_from_wit

  # ---SAMPLE DATA---
  # location = 'Kim Bôi, Hoà Bình'
  # audio_url = ''
  # transcript = 'Tôi đang ở Kim Bôi, Hoà Bình. Tôi muốn báo cáo về một trường hợp tiêu chảy cấp và sốt cao ở gần nhà tôi.'
  # symptoms = ['sốt xuất huyết', 'sốt']
  # cases = 4
  # text = symptoms.push(cases.to_s).join(', ')

  transcript = raw_data['_text']
  entities = raw_data['entities']

  raw_locations = []
  raw_locations = entities['location'] if entities['location']
  locations = []
  raw_locations.each do |l|
    locations.push(l['value'])
  end
  puts locations

  raw_diseases = []
  raw_diseases = entities['disease'] if entities['disease']
  diseases = []
  diseases.each do |d|
    diseases.push(d['value'])
  end

  data = Hash['transcript', transcript, 'raw_locations', raw_locations, 'locations', locations, 'raw_diseases', raw_diseases, 'diseases' ,diseases]

  # PUSH TO FIREBASE AND GET THE RESPONSE
  firebase = Firebase::Client.new(BASE_URL)
  response = firebase.push("raw_data", data)
  puts response.success?, response.raw_body
end
# 
# tmp = {
#   "msg_id"=>"0R0Fsy4j3f7IAi245",
#   "_text"=>"Tôi đang ở Kim Bôi, Hoà Bình. Tôi muốn báo cáo về một trường hợp tiêu chảy cấp và sốt cao ở gần nhà tôi",
#   "entities"=>{
#     "location"=>[
#       {"suggested"=>true, "confidence"=>0.88001, "value"=>"Bôi", "type"=>"value"},
#       {"suggested"=>true, "confidence"=>0.918715, "value"=>"Hoà Bình", "type"=>"value"}
#     ],
#     "disease"=>[
#       {"confidence"=>0.96492664345812, "value"=>"tiêu chảy", "type"=>"value"},
#       {"confidence"=>0.95828188504701, "value"=>"sốt", "type"=>"value"}
#     ]
#   }
# }
# pusher(tmp)
