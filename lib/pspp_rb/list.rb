module PsppRb
  class List
    include Enumerable

    attr_reader :variables, :rows

    def initialize(variables)
      self.variables = variables
      self.rows = []
    end

    def append_row(row)
      raise ArgumentError, "row must be Row, got #{row.class}" unless row.is_a?(Row)
      rows << row
    end

    def <<(row)
      append_row(row)
    end

    def each
      rows.each { |row| yield row }
    end

    def to_pspp
      # NOTE the data can be large, so it's important to mutate single string
      data = "#{pspp_definition}\n"
      variables.select { |var| var.level }.each do |var|
        data << "variable level #{var.to_pspp_level}\n"
      end
      data << "begin data.\n"
      each do |row|
        data << "#{row.to_pspp}\n"
      end
      data << "end data.\n"
      data
    end

    private

    attr_writer :variables, :rows

    def pspp_definition
      "data list list /#{variables.map(&:to_pspp_definition).join(' ')}."
    end
  end
end
