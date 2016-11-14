module PsppRb
  class Variable
    class Label
      attr_accessor :data

      def initialize(data)
        self.data = data
      end

      def to_pspp
        if data
          PsppRb::Escape.run(data)
        else
          ''
        end
      end

      def to_s
        data
      end

      def inspect
        to_s
      end
    end
  end
end
