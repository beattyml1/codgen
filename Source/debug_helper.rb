module DebugHelper
  def self.write_file(name, text)
    File.write('../debug_data/'+name, text)
  end
end