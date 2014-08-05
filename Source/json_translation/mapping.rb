module Mapping
  def self.map_object(json_data, json_map_data)
    if json_data != nil && json_data.is_a?(Array)
      json_data.each do |item|
        map_object(item, json_map_data)
      end
      return
    end

    add_entries = Hash.new
    json_data.each do |key, value|
      if value != nil && value.is_a?(Array) || value.is_a?(Hash)
        map_object(value, json_map_data)
        next
      end

      map = json_map_data[key]
      if map != nil
        map.each do |output_key, value_map|
          unless json_data.has_key?(output_key)
            output_value = value
            value_map.each do |match_expr, map_value|
              if Regexp.new(match_expr).match(value)
                output_value = map_value
                break
              end
            end
            add_entries.store(output_key, output_value)
          end
        end
      end
    end

    add_entries.each do |key, value|
      json_data.store(key, value)
    end
  end
end