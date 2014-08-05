module Logger
  def self.error(message)
    puts message
    exit 1
  end
end