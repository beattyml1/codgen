class Template
  def initialize(parent, name)
    @parent = parent
    @name = name
    @remaining_text = ''
    @templates = Hash.new
    @text = ''
  end


  def parse(remaining_text)
    @remaining_text = remaining_text

    if @remaining_text.length == 0
      return ''
    end

    loop do
      template_tag_start_index = @remaining_text.index('<<<')

      if template_tag_start_index == nil
        @text += @remaining_text
        return ''
      end

      before_text = @remaining_text[0...template_tag_start_index]
      @text += before_text

      @remaining_text = @remaining_text[template_tag_start_index+3...@remaining_text.length]

      tag_type = get_next_word()

      template_name = get_next_word()

      template_tag_end_index = @remaining_text.index('>>>')

      @remaining_text = @remaining_text[template_tag_end_index+3, @remaining_text.length-3-template_tag_end_index]

      if tag_type == 'start'
        template = Template.new(self, template_name)
        @templates.store(template_name, template)
        @text += '{{'+template_name+'}}'
        @remaining_text = template.parse(@remaining_text)
      elsif tag_type == 'end'
        if template_name == @name
          return @remaining_text
        else
          throw "Template close tag '"+template_name+"' does not match template start tag '"+@name+"'"
        end
      else
        throw "Expected template end tag for '"+@name+"' encounterd end tag for '"+template_name+"'"
      end
    end
  end


  def get_fill_template_list(template_name, template_array, levels)
    template_list_output = ''

    template_array.each do |template_data|
      template = @templates[template_name]

      next if template == nil

      next_level = template_data
      next_levels = Array.new(levels).insert(0, next_level)

      template_list_output += template.fill(next_levels)
    end

    template_list_output
  end



  def fill(levels)
    current_filled_template = @text

    levels[0].each do |key, value|
      if value.is_a?(Array)
        filled_templates = get_fill_template_list(key, value, levels)
        current_filled_template = get_fill_single_field(key, filled_templates , current_filled_template)
      end
    end

    levels.each do |level|
      if level.is_a?(Array)
        next
      end

      level.each do |key, value|
        if value.is_a?(String)
          current_filled_template = get_fill_single_field(key, value, current_filled_template)
        elsif !!value == value
          current_filled_template = get_fill_single_switch(key, value, current_filled_template)
        end
      end
    end

    current_filled_template
  end


  def name
    @name
  end

  def get_fill_single_field(name, value, current_filled_template)
    current_filled_template.gsub('{{'+name+'}}', value)
  end


  def get_fill_single_switch(name, value, current_filled_template)
    regex = Regexp.new('^.*##:'+name+'\?.*$') # Should match lines ending with ##:name?
    matches = current_filled_template.scan(regex)

    if value
      matches.each do |match|
        inserted_line = match.sub('##:'+name+'?', '')
        current_filled_template.sub!(match, inserted_line)
      end
    else
      matches.each do |match|
        line_start = current_filled_template.index(match)
        current_filled_template.gsub!(match, '')
        current_filled_template = current_filled_template[0...line_start-1] + current_filled_template[line_start...current_filled_template.length]
      end
    end
    current_filled_template
  end


  def get_next_word
    @remaining_text = @remaining_text.lstrip

    id = ''

    while is_id_char(@remaining_text[0])
      id += @remaining_text[0]

      if @remaining_text.length > 1
        @remaining_text = @remaining_text[1...@remaining_text.length]
      else
        throw 'Expected end of tag or next word'
      end
    end

    @remaining_text = @remaining_text.rstrip

    return id
  end


  def is_id_char(input_string)
    first_match = input_string.index(/[a-zA-Z0-9_%$#]/)
    first_match == 0
  end
end
