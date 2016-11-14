module PsppRb
  class Escape
    class << self
      def run(text)
        return text if text.is_a?(Numeric)
        raise PsppError, "text must be String or Numeric, got #{text.class}" unless [String, Numeric].any? { |i| text.is_a?(i) }
        result = text.dup
        result = strip_non_printable_characters(result)
        result = workaround_quotations(result)
        result
      end

      private

      def strip_non_printable_characters(text)
        text.gsub(/[^[:print:]]+/, ' ')
      end

      # rubocop: disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def workaround_quotations(text)
        if single_quote?(text) && !double_quote?(text)
          double_quoted(text)
        elsif double_quote?(text) && !single_quote?(text)
          single_quoted(text)
        elsif single_quote?(text) && double_quote?(text)
          single_quoted(text.tr("'", "\u2019"))
        else
          single_quoted(text)
        end
      end
      # rubocop: enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      def single_quote?(text)
        text.include?("'")
      end

      def double_quote?(text)
        text.include?('"')
      end

      def single_quoted(text)
        "'#{text}'"
      end

      def double_quoted(text)
        "\"#{text}\""
      end
    end
  end
end
