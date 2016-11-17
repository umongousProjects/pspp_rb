require 'securerandom'
require 'pspp_rb/pspp/exec'
require 'pspp_rb/pspp/log'

module PsppRb
  class Pspp
    attr_reader :log, :pspp_exec

    def initialize(pspp_cli_path: 'pspp', env: {})
      self.pspp_exec = Exec.new(pspp_cli_path, env)
      self.log = Log.new
    end

    def execute(commands)
      success = pspp_exec.execute(commands, log.error_file_path, log.output_file_path)
      log.read!
      check_execution_result!(commands, success)
    ensure
      log.utilize!
    end

    private

    attr_writer :log, :pspp_exec

    def check_execution_result!(commands, success)
      ct = text_excerpt(commands)
      return true if success && log.success?
      raise PsppError, "error executing pspp commands `#{ct}`\n*** PSPP LOG ***\n#{log}\n*** END OF PSPP LOG ***"
    end

    def text_excerpt(text, maxlen: 300, omission: '...')
      return text if text.length < maxlen
      text[0..(maxlen - omission.length)] + omission
    end
  end
end
