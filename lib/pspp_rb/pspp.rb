require 'open3'
require 'securerandom'

module PsppRb
  class Pspp
    attr_reader :log, :pspp_cli_path

    def initialize(pspp_cli_path: 'pspp')
      self.pspp_cli_path = Shellwords.shellescape(pspp_cli_path)
      raise PsppError, "cannot execute '#{self.pspp_cli_path}' program" unless system(self.pspp_cli_path, '--version')
    end

    def execute(commands)
      self.log = ''
      err_log_file = error_log_file_path
      out_log_file = output_log_file_path
      success = execute_commands(commands, err_log_file, out_log_file)
      check_execution_result!(commands, success)
    ensure
      delete_file(out_log_file)
      delete_file(err_log_file)
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

    private

    attr_writer :log, :pspp_cli_path

    def check_execution_result!(commands, success)
      ct = text_excerpt(commands)
      et = text_excerpt(errors.join("\n  "))
      raise PsppError, "error executing pspp commands '#{ct}':\n  #{et}\n *** PSPP LOG ***\n#{log}\n*** END OF PSPP LOG ***" if !success? || !success
    end

    def text_excerpt(text, maxlen: 200, omission: '...')
      return text if text.length < maxlen
      text[0..(maxlen - omission.length)] + omission
    end

    def error_log_file_path
      File.join(Dir.tmpdir, 'pspp_errors_' + SecureRandom.hex)
    end

    def output_log_file_path
      File.join(Dir.tmpdir, 'pspp_output_' + SecureRandom.hex)
    end

    def read_to_log(filepath)
      log << File.read(filepath) if File.exist?(filepath)
    end

    def delete_file(filepath)
      File.delete(filepath) if File.exist?(filepath)
    end

    def execute_commands(commands, err_log_file, out_log_file)
      result = false
      Open3.popen3(pspp_cli_path, '-b', '-o', out_log_file, '-e', err_log_file) do |stdin, _stdout, _stderr, wait_thr|
        stdin.write(commands)
        stdin.close
        result = wait_thr.value.success?
      end
      result
    ensure
      read_to_log(out_log_file)
      read_to_log(err_log_file)
    end
  end
end
