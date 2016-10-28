require 'open3'

module PsppRb
  class Pspp
    attr_reader :log, :command

    def initialize(command: 'pspp')
      self.command = Shellwords.shellescape(command)
      raise PsppError, "cannot execute '#{command}' program" unless system(self.command, '--version')
    end

    def export(list, outfile)
      raise ArgumentError, "list must be List, got #{list.class}" unless list.is_a?(List)
      raise ArgumentError, "outfile must be String, got #{outfile.class}" unless outfile.is_a?(String)

      self.log = nil
      
      Open3.popen3(command + ' --batch') do |i, o, _, _|
        i.write(list.to_pspp)
        i.write("save outfile='#{outfile}'.\n")
        i.write('finish.')
        i.close
        self.log = o.read
      end
      success?
    end

    def errors
      return [] unless log
      log.scan(/(error.*)/).flatten
    end

    def success?
      errors.empty?
    end

    private

    attr_writer :log, :command
  end
end
