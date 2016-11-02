module PsppRb
  class Variable
    class Level
      attr_accessor :data

      def self.available_levels
        %w(NOMINAL SCALE ORDINAL)
      end

      def initialize(data)
	 raise ArgumentError, "level must be one of #{self.class.available_levels.join(', ')}" unless self.class.available_levels.include?(data)
        self.data = data
      end

      def to_pspp
        data
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
