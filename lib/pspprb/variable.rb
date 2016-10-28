require 'pspprb/variable/type'

module Pspprb
  class Variable
    attr_accessor :name, :type

    def initialize(name, type = nil)
      raise ArgumentError, "name must be String, got #{name.class}" unless name.is_a?(String)
      raise ArgumentError, "type must be Variable::Type, got #{type.class}" if !type.is_a?(Type) && !type.nil?
      self.type = type
      self.name = name
    end

    def to_s
      if type
        "#{name}(#{type.to_pspp})"
      else
        name
      end
    end

    def inspect
      to_s
    end

    def to_pspp
      to_s
    end
  end
end
