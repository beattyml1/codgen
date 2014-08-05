class CommandLineArguments
  def initialize(arguments)
    if arguments.count < 1
      puts 'Invalid argument count, arguments should be like: data.json template.cs ouput.json [optional-map.json]'
      exit 1
    end

    if arguments.count == 1
      @json_config = arguments[0]
    end
  end

  attr_reader :json_config
end