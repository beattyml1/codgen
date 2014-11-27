module Codgen
  module Flattener

    # @param [Hash] data_root: the JSON root hash
    # @param [Array[String]] properties
    # @return [Array, Hash]
    def self.merge(data_root, properties)
      current = data_root
      obj_out = Hash.new
      properties.each { |property|
        current.each {|prop, val| obj_out[prop] = val}
        current = current[property]
      }

      if current.is_a?(Hash)
        current.each {|prop, val| obj_out[prop] = val}
        return obj_out
      elsif current.is_a?(Array)
        array_out = Array.new
        current.each { |child|
          if child.is_a?(Hash)
            array_obj = Hash.new
            obj_out.each {|prop, val| array_obj[prop] = val}
            child.each {|prop, val| array_obj[prop] = val}
            array_out.push(array_obj)
          end
        }
        return array_out
      end
    end
  end
end