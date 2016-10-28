module Pspprb
  class Row
    attr_reader :cells

    def initialize
      self.cells = []
    end

    def append_cell(cell)
      raise ArgumentError, "cell must be Cell, got #{cell.class}" unless cell.is_a?(Cell)
      cells << cell
    end

    def <<(cell)
      append_cell(cell)
    end

    def to_s
      "[#{cells.map(&:to_s).join(', ')}]"
    end

    def inspect
      to_s
    end

    def to_pspp
      cells.map(&:to_pspp).join(' ')
    end

    private

    attr_writer :cells
  end
end
