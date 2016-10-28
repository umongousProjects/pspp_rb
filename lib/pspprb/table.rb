module Pspprb
  class Table
    include Enumerable

    attr_reader :header, :rows

    def initialize(variables)
      self.header = variables
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
      "data list list /#{header.map(&:to_pspp).join(' ')}."
    end

    private

    attr_writer :header, :rows
  end
end
