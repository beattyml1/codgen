require_relative '../regular_expressions'
require 'securerandom'
require_relative '../utilities/logger'
require_relative 'template'
require_relative 'conditional'
require_relative 'statement'

class Parser
  include RegularExpressions
  public
  def initialize(file_stream)
    @file_stream = file_stream
  end

  def self.parse(file_stream)
    parser = Parser.new(file_stream)
    parser.parse_section(Section.new(nil, 'root'))
  end


  def parse_section(current_section)
    until @file_stream.eof
      line = @file_stream.readline

      macros = line.scan(MACRO_REGEX)
      if macros.count > 1
        Logger.error('Cannot have multiple macros on the same line')
      elsif macros.count == 1
        macro = macros[0]
        macro_name = macro.scan(IDENTIFIER_REGEX)[0]
        value = line.sub(macro, '').strip
        current_section.macros_unfilled[macro_name] = value
        next
      end

      tags = line.scan(TAG_REGEX)
      if tags.count > 1
        Logger.error('Cannot have multiple template tags on the same line')
      elsif tags.count == 1
        tag = tags[0]
        if tag.index(TEMPLATE_START_TAG_REGEX)
          id = tag.scan(IDENTIFIER_REGEX)[1]
          process_subsection_parse(current_section, Template.new(current_section, id))
        elsif tag.index(TEMPLATE_END_TAG_REGEX)
          id = tag.scan(IDENTIFIER_REGEX)[1]
          if id == current_section.name && current_section.is_a?(Template)
            return current_section
          else
            Logger.error('End tag encountered that that does not correspond with the current start tag')
          end
        elsif tag.index(IF_TAG_REGEX)
          create_and_process_new_conditional(current_section, 'if', @file_stream, tag, true, nil)
        elsif tag.index(ELSEIF_TAG_REGEX)
          create_and_process_new_conditional(current_section.parent, 'elseif', @file_stream, tag, true, current_section)
          return current_section
        elsif tag.index(ELSE_TAG_REGEX)
          create_and_process_new_conditional(current_section.parent, 'else', @file_stream, tag, false, current_section)
          return current_section
        elsif tag.index(ENDIF_TAG_REGEX)
          create_and_process_new_conditional(current_section.parent, 'endif', @file_stream, tag, false, current_section)
          return current_section
        else
          Logger.error("Tag's first word must be start or end and it's second must be  valid identifier")
        end
      else
        current_section.text += line
      end
    end
    current_section
  end


  private
  def process_subsection_parse(current_section, new_section)
    current_section.sections.store(new_section.name, new_section)
    current_section.text += "{{#{new_section.name}}}"
    parse_section(new_section)
  end


  def create_and_process_new_conditional(current_section, type, file_stream, tag, has_condition, previous_condition)
    if previous_condition != nil && !previous_condition.is_a?(Conditional)
      Logger.error('elseif must have a corresponding if')
    end

    section = Conditional.new(current_section, type+SecureRandom.uuid.tr('-', ''), previous_condition)

    if has_condition
      statement_text = tag.scan(STATEMENT_REGEX)[0].sub(/elseif|else|endif|if/, '').strip
      section.statement = Statement.new
      section.statement.parse(statement_text)
    end

    process_subsection_parse(current_section, section)
  end
end