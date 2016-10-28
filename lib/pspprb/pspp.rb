require 'open3'

module Pspprb
  class Pspp
    attr_accessor :outfile, :command, :table
    attr_reader :log

    def initialize(outfile, table, command: 'pspp')
      raise PsppError, "cannot execute '#{command}' program" unless system(Shellwords.shellescape(command), '--version')
      raise ArgumentError, "table must be Table, got #{table.class}" unless table.is_a?(Table)
      raise ArgumentError, "outfile must be String, got #{outfile.class}" unless outfile.is_a?(String)
      self.outfile = outfile
      self.command = command
      self.table = table
    end

    def export
      Open3.popen3(command) do |i, o, _, _|
        i.write(prepared_input_data)
        i.close
        self.log = o.read
      end
      success?
    end

    def errors
      return [] unless log
      log.scan(/(error:.*)/).flatten
    end

    def success?
      errors.empty?
    end

    private

    attr_writer :log

    def prepared_input_data
      # NOTE the data can be large, so it's important to mutate single string
      data = "#{table.to_pspp}\n"
      data << "begin data.\n"
      table.each do |row|
        data << "#{row.to_pspp}\n"
      end
      data << "end data.\n"
      data << "save outfile='#{outfile}'.\n"
      data << "finish.\n"
      data
    end
  end
end
