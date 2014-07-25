module AutoStyle
  public
  def self.style_casing(json_object)
    if json_object.is_a?(Array)
      json_object.each { |child| style_casing(child) }
    end

    add_props = Hash.new
    if json_object.is_a?(Hash)
      json_object.each do |key, value|
        if value.is_a?(Hash) || value.is_a?(Array)
          style_casing(value)
          next
        end

        if key.index(' ') || key.index('%')
          add_props.store(key, value)
        end
      end
    end

    add_props.each do |key, value|
      add_property_group(json_object, key, value, AutoStyle.method(:to_camel), '%camelCase')
      add_property_group(json_object, key, value, AutoStyle.method(:to_cap_camel), '%CapCamel')
      add_property_group(json_object, key, value, AutoStyle.method(:to_underscore), '%underscored')
      add_property_group(json_object, key, value, AutoStyle.method(:to_camel), '%CAPS_UNDERSCORE')
    end
  end


  private
  def self.add_property_group(json_object, key, value, translate, explicit_postfix)
    should_translate_val = value != nil && value.is_a?(String)

    new_key = translate.call(key)
    new_value = should_translate_val ? translate.call(value) : value

    try_add_prop(json_object, new_key, new_value)
    try_add_prop(json_object, new_key+explicit_postfix, new_value)
  end


  def self.try_add_prop(json_object, key, value)
    if !json_object.has_key?(key)
      json_object.store(key, value)
    end
  end


  def self.to_universal(input_string)
    output_string = input_string.tr('%', '')
    output_string.split(' ')
  end


  def self.to_cap_camel(input_string)
    universal = to_universal(input_string)
    universal.each {|word| word[0] = word[0].upcase}
    universal.join('')
  end


  def self.to_camel(input_string)
    universal = to_universal(input_string)
    universal[1...universal.count].each {|word| word[0] = word[0].upcase}
    universal.join('')
  end


  def self.to_underscore(input_string)
    universal = to_universal(input_string)
    output = universal.join('_')
    output.downcase
  end


  def self.to_allcaps_underscore(input_string)
    universal = to_universal(input_string)
    output = universal.join('_')
    output.upcase
  end
end