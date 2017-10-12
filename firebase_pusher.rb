require 'firebase'

class FirebasePusher

  attr_reader :db_url

  def initialize db_url
    @db_url = db_url
  end

  ###
  # json_response = {
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
  ###
  def push json_response
    raw_data = json_response

    transcript = json_response['_text']
    caller = json_response['caller']
    audio_url = json_response['audio_url']

    entities = json_response['entities']

    raw_locations = []
    raw_locations = entities['location'] if entities['location']
    locations = []
    raw_locations.each do |location|
      locations.push(location['value'])
    end

    raw_diseases = []
    raw_diseases = entities['disease'] if entities['disease']
    diseases = []
    raw_diseases.each do |disease|
      diseases.push(disease['value'])
    end

    data = {
      caller_number: caller,
      audio_url: audio_url,
      transcript: transcript,
      raw_locations: raw_locations,
      locations: locations,
      raw_diseases: raw_diseases,
      diseases: diseases
    }

    # PUSH TO FIREBASE AND GET THE RESPONSE
    firebase = Firebase::Client.new(@db_url)
    response = firebase.push("raw_data", data)
    puts response.success?, response.raw_body
  end
end
