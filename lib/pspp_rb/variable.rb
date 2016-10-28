module PsppRb
  class Variable
    attr_accessor :name, :format, :level

    Levels = %w(NOMINAL SCALE ORDINAL)

    def initialize(name:, format: nil, level: nil)
      raise ArgumentError, "name must be String, got #{name.class}" unless name.is_a?(String)
      raise ArgumentError, "format must be String, got #{format.class}" if !format.is_a?(String) && !format.nil?
      raise ArgumentError, "level must be String, got #{level.class}" if !level.is_a?(String) && !level.nil?
      self.format = format
      self.name = name
      self.level = level
    end

    def to_s
      if format
        "#{name}(#{format})"
      else
        name
      end
    end

    def inspect
      to_s
    end

    def to_pspp_definition
      to_s
    end

    def to_pspp_level
      if level
        "#{name} (#{level})"
      else
        name
      end
    end
  end
end
