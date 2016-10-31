require 'pspp_rb/variable/level'
require 'pspp_rb/variable/label'
require 'pspp_rb/variable/value_label'

module PsppRb
  class Variable
    attr_accessor :name, :format, :level, :label, :value_labels

    def initialize(name:, format: nil, level: nil, label: nil, value_labels: {})
      raise ArgumentError, "name must be String, got #{name.class}" unless name.is_a?(String)
      raise ArgumentError, "format must be String, got #{format.class}" if format && !format.is_a?(String)

      self.format = format
      self.name = name
      self.level = Level.new(level) if level
      self.label = Label.new(label) if label
      initialize_value_labels(value_labels)
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

    def to_pspp
      data = ''
      data << pspp_level
      data << pspp_label
      data << pspp_value_labels
      data
    end

    private

    def pspp_level
      if level
        "variable level #{name} (#{level.to_pspp}).\n"
      else
        ''
      end
    end

    def pspp_label
      if label
        "variable labels #{name} #{label.to_pspp}.\n"
      else
        ''
      end
    end

    def pspp_value_labels
      if value_labels.any?
        "value labels /#{name} #{value_labels.map(&:to_pspp).join(' ')}.\n"
      else
        ''
      end
    end

    def initialize_value_labels(vls)
      raise ArgumentError, "value_labels must be Hash, got #{value_labels.class}" unless vls.is_a?(Hash)
      self.value_labels = []
      vls.each do |k, v|
        value_labels << ValueLabel.new(k, v)
      end
    end
  end
end
