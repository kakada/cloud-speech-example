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
    reported_at = json_response['reported_at']
    caller = json_response['caller']
    audio_url = json_response['audio_url']

    entities = json_response['entities']

    raw_locations = entities['location'] ? entities['location'] : []
    locations = raw_locations.map { |location| location['value'] }

    raw_diseases = entities['disease'] ? entities['disease'] : []
    diseases = raw_diseases.map { |disease| disease['value'] }

    raw_cases = entities['number'] ? entities['number'] : []
    cases = raw_cases.map { |kase| kase['value'] }
    

    data = {
      caller_number: caller,
      reported_at: reported_at,
      audio_url: audio_url,
      transcript: transcript,
      raw_locations: raw_locations,
      locations: locations,
      raw_diseases: raw_diseases,
      diseases: diseases,
      raw_diseases: raw_diseases,
      cases: cases,
      raw_cases: raw_cases
    }

    # PUSH TO FIREBASE AND GET THE RESPONSE
    firebase = Firebase::Client.new(@db_url)
    response = firebase.push("raw_data", data)
    puts response.success?, response.raw_body
  end

end
