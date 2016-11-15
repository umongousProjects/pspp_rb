require 'securerandom'

module PsppRb
  class Pspp
    class Log
      attr_reader :error_file_path, :output_file_path, :log

      def initialize
        initialize_files
      end

      def read!
        self.log = ''
        read_file(output_file_path)
        read_file(error_file_path)
      end

      def utilize!
        delete_file(error_file_path)
        delete_file(output_file_path)
        initialize_files
      end

      def errors
        return [] unless log
        log.scan(/(error.*)/).flatten
      end

      def warnings
        return [] unless log
        log.scan(/(warning.*)/).flatten
      end

      def success?
        errors.empty? && warnings.empty?
      end

      def to_s
        log
      end

      private

      attr_writer :error_file_path, :output_file_path, :log

      def initialize_files
        self.error_file_path = generate_temp_file_path('pspp_errors_')
        self.output_file_path = generate_temp_file_path('pspp_output_')
      end

      def generate_temp_file_path(prefix = '', suffix = '')
        File.join(Dir.tmpdir, prefix + SecureRandom.hex + suffix)
      end

      def read_file(filepath)
        log << File.read(filepath) if File.exist?(filepath)
      end

      def delete_file(filepath)
        File.delete(filepath) if File.exist?(filepath)
      end
    end
  end
end
