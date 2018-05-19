require_relative 'setting.rb'

class Logger
  def self.log message
    begin
      File.open(Setting.output_log_file, 'a') { |f| f.puts message }
    rescue Exception => e
      puts "File #{Setting.output_log_file} doesn't exist"
    end
  end
end
