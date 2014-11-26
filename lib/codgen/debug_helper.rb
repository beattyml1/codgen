module DebugHelper
  @@event_log = nil

  def self.write_file(name, text)
    File.write('../debug_data/'+name, text)
  end

  def self.log_event(message)
    if @@event_log == nil
      @@event_log = File.new('../debug_data/event_log', 'w+')
    end

      @@event_log.write("#{Time.now}: #{message}\n")
  end
end