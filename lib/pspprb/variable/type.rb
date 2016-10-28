module Pspprb
  class Variable
    class Type
      attr_accessor :definition

      def initialize(definition)
        self.definition = definition
      end

      def to_s
        definition
      end

      def inspect
        to_s
      end

      def to_pspp
        definition
      end
    end
  end
end
