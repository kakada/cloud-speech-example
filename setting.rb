require 'yaml'

SETTING_YML_FILE = 'setting.yml'

class Setting

  class << self
    def verboice_url
      config()['VERBOICE_URL']
    end

    def verboice_first_audio_file
      config()['VERBOICE_FIRST_AUDIO_FILE']
    end

    def google_api_key
      config()['GOOGLE_API_KEY']
    end

    def language_recognition
      config()['LANGUAGE_RECOGNITION']
    end

    def firebase_db_url
      config()['FIREBASE_DB_URL']
    end

    def wit_token
      config()['WIT_TOKEN']
    end

    def output_log_file
      config()['OUTPUT_LOG_FILE']
    end

    private

    def config
      @@SETTING ||= YAML::load_file(File.join(__dir__, SETTING_YML_FILE)) rescue {}
    end
  end
  
end
