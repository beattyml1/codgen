require_relative '../string_constants'

module PostFillTasks
  include StringConstants

  def self.process_escapes(input_text)
    result =''

    current_index = 0
    while current_index < input_text.length
      current_char = input_text[current_index]
      if current_char == ESCAPE_CHARACTER && current_index + 1 < input_text.length
        result.concat(input_text[current_index + 1])
        current_index += 2
      else
        result.concat(current_char)
        current_index += 1
      end
    end
    result
  end

end