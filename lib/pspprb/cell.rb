module Pspprb
  class Cell
    attr_accessor :data

    def initialize(data)
      self.data = data.to_s
    end

    def to_s
      "<#{data}>"
    end

    def inspect
      to_s
    end

    def to_pspp
      data
    end
  end
end
