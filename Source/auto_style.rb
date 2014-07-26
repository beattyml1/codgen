require 'active_support/inflector'

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

        if key.index(/[#@ ]/)
          add_props.store(key, value)
        end
      end
    end

    add_props.each do |key, value|
      pluralize = key.index(/(?i)#singular/)
      singularize = key.index(/(?i)#plural/)
      add_property_group(json_object, key, value, pluralize, singularize, AutoStyle.method(:to_camel), '%camelCase')
      add_property_group(json_object, key, value, pluralize, singularize, AutoStyle.method(:to_cap_camel), '%CapCamel')
      add_property_group(json_object, key, value, pluralize, singularize, AutoStyle.method(:to_underscore), '%underscored')
      add_property_group(json_object, key, value, pluralize, singularize, AutoStyle.method(:to_camel), '%CAPS_UNDERSCORE')
    end
  end


  private
  def self.add_property_group(json_object, key, value, pluralize, singularize, translate, explicit_postfix)
    should_translate_val = value != nil && value.is_a?(String) && key.index('@')
    is_plural = key.index('#plural')

    new_key = translate.call(key)
    new_value = should_translate_val ? translate.call(value) : value
    explicit_key = new_key + explicit_postfix

    requantified = pluralize_singularize(new_key, explicit_key, new_value, is_plural, should_translate_val)

    try_add_prop(json_object, new_key, new_value)
    try_add_prop(json_object, explicit_key, new_value)
    try_add_prop(json_object, requantified.short_key, requantified.value)
    try_add_prop(json_object, requantified.explicit_key, requantified.value)
  end

  def self.pluralize_singularize(short_key, explicit_key, value, is_plural, should_translate_value)
    return_obj = OpenStruct.new
    if !is_plural
      return_obj.short_key = short_key.pluralize
      return_obj.explicit_key = explicit_key.pluralize
      return_obj.value = should_translate_value ? value.pluralize : value
    else
      return_obj.short_key = short_key.singularize
      return_obj.explicit_key = explicit_key.singularize
      return_obj.value = should_translate_value ? value.singularize : value
    end
    return_obj
  end


  def self.try_add_prop(json_object, key, value)
    if !json_object.has_key?(key)
      json_object.store(key, value)
    end
  end


  def self.to_universal(input_string)
    output_string = input_string.tr('$#$@', '')
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