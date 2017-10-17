class Logger

  LOG_FILE = '/tmp/recognize.txt'

  def self.log message
    begin
      File.open(LOG_FILE, 'a') { |f| f.puts message }
    rescue Exception => e
      puts "File #{LOG_FILE} doesn't exist"
    end
  end
end
