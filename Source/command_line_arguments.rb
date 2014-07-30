class CommandLineArguments
  def initialize(arguments)
    if arguments.count < 3
      puts 'Invalid argument count, arguments should be like: data.json template.cs ouput.json [optional-map.json]'
      exit 1
    end

    @json_data_filename = arguments[0]
    @template_filename = arguments[1]
    @output_filename = arguments[2]

    if arguments.count == 4
      @json_map_filename = arguments[3]
    else
      @json_map_filename = nil
    end
  end


  def json_data_filename
    @json_data_filename
  end


  def template_filename
    @template_filename
  end


  def json_map_filename
    @json_map_filename
  end


  def output_filename
    @output_filename
  end
end