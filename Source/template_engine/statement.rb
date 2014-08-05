require_relative '../regular_expressions'
require_relative '../utilities/logger'

class Statement
  include RegularExpressions

  def initialize(operator=nil)
    @words = Array.new
    @operator = operator
  end

  def evaluate(get_val)
    if @operator == nil
      expand
    end

    current_val = nil
    @words.each do |child|
      current_val = accumulate(current_val, child, @operator, get_val)
    end
    current_val
  end

  attr_reader :operator
  attr_reader :words

  def accumulate(before, child, operator, get_val)
    if operator == nil && child.is_a?(Statement)
      accumulate(before, child, child.operator, get_val)
    else
      value = child.is_a?(String) ? get_val.call(child) : child.evaluate(get_val)
      case operator
        when :and
          before = before != nil ? before : true
          before && value
        when :or
          before = before != nil ? before : false
          before || value
        when :not
          !value
        else
          value
      end
    end
  end

  def expand
    expand_not
    expand_and
    expand_or
  end

  def parse(text)
    count = -1
    text.each_char do |current_char|
      count+=1
      if current_char == ' '
        next 1
      end

      if current_char.index(IDENTIFIER_REGEX)
        if @words.length > 0 && @words[-1].index(IDENTIFIER_REGEX)
          @words[-1] = @words[-1] + current_char
        else
          @words.push(current_char)
        end
      elsif current_char.index(/[&|!]/)
        @words.push(current_char)
      elsif current_char == '('
        @words.push(Statement.new)
        count += @words[-1].parse(text[count...text.length])
      elsif current_char == ')'
        return count
      end
    end
  end

  def expand_not
    new_words = Array.new
    @words.each do |word|
      if word.is_a?(Statement)
        new_words.push(word)
      elsif word.index(/not|!/)
        if new_words[-1].is_a?(Statement) && new_words[-1].operator == :not
          new_words.delete_at(-1)
        else
          new_words.push(Statement.new(:not))
        end
      else
        if new_words[-1].is_a?(Statement) && new_words[-1].operator == :not && new_words[-1].words.count == 0
          new_words[-1].words.push(word)
        else
          new_words.push(word)
        end
      end
    end
    @words = new_words
  end

  def expand_and
    new_words = Array.new
    index = -1
    skip = false
    @words.each do |word|
      index+=1
      if skip
        skip = false
        next
      end
      if word.is_a?(Statement)
        new_words.push(word)
      elsif word.index(/and|&/)
        if new_words.count > 0 && @words.count > index + 1
          left = new_words[-1]
          new_words.delete_at(-1)
          new_words.push(Statement.new(:and))
          new_words[-1].words.push(left)
          new_words[-1].words.push(@words[index+1])
          skip = true
          next
        else
          throw 'Operator must have a left and a right side'
        end
      else
        new_words.push(word)
      end
    end
    @words = new_words
  end

  def expand_or
    new_words = Array.new
    index = -1
    skip = false
    @words.each do |word|
      index+=1
      if skip
        skip = false
        next
      end
      if word.is_a?(Statement)
        new_words.push(word)
      elsif word.index(/or|\|/)
        if new_words.count > 0 && @words.count > index + 1
          left = new_words[-1]
          new_words.delete_at(-1)
          new_words.push(Statement.new(:or))
          new_words[-1].words.push(left)
          new_words[-1].words.push(@words[index+1])
          skip = true
          next
        else
          throw 'Operator must have a left and a right side'
        end
      else
        new_words.push(word)
      end
    end
    @words = new_words
  end
end