require 'pspp_rb/version'
require 'pspp_rb/pspp'
require 'pspp_rb/data_set'
require 'pspp_rb/case'
require 'pspp_rb/variable'
require 'pspp_rb/pspp_error'

module PsppRb
  def self.dummy
    variables = [Variable.new(name: 'VAR0', format: 'F4.1', level: 'ORDINAL', label: 'make const not var'),
                 Variable.new(name: 'VAR1', format: 'A50', level: 'NOMINAL'),
                 Variable.new(name: 'VAR2', format: 'F9.4'),
                 Variable.new(name: 'VAR3', value_labels: { 1 => 'one', 2 => 'two' })]

    dataset = DataSet.new(variables)

    1.upto(15) do |i|
      values = [100 * i,
                'text' * i,
                200 * i,
                i % 2 + 1]
      cas = Case.new(values)
      dataset << cas
    end

    export(dataset, '/home/oleg/Desktop/heeee.sav')
  end

  def self.export(dataset, outfile)
    raise ArgumentError, "dataset must be DataSet, got #{dataset.class}" unless dataset.is_a?(DataSet)
    raise ArgumentError, "outfile must be String, got #{outfile.class}" unless outfile.is_a?(String)

    commands = dataset.to_pspp
    commands << "save outfile='#{outfile}'.\n"
    commands << 'finish.'

    pspp = Pspp.new
    pspp.execute(commands)
  end
end
