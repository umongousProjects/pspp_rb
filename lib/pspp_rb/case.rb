module PsppRb
  class Case
    attr_reader :values

    def initialize(values = [])
      self.values = []
      values.each { |v| append_value(v) }
    end

    def append_value(value)
      raise PsppError, "value must be String or Numeric, got #{value.class}" unless [String, Numeric].any? { |i| value.is_a?(i) }
      values << value
    end

    def <<(value)
      append_value(value)
    end

    def to_s
      "[#{values.map(&:to_s).join(', ')}]"
    end

    def inspect
      to_s
    end

    def to_pspp
      values.map { |i| PsppRb.escape_data(i) }.join(' ') + "\n"
    end

    private

    attr_writer :values
  end
end
