require 'pspp_rb/version'
require 'pspp_rb/pspp'
require 'pspp_rb/data_set'
require 'pspp_rb/case'
require 'pspp_rb/variable'
require 'pspp_rb/pspp_error'
require 'pspp_rb/escape'
require 'tempfile'

module PsppRb
  # rubocop: disable Metrics/MethodLength, Metrics/AbcSize
  def self.dummy
    require 'benchmark'

    cases = 1_000
    # benchmark @ core m7-6Y75 8gb
    # 100_000 cases =>   0.570000   0.000000   1.130000 (  1.124553)
      variables = [Variable.new(name: 'VAR0', format: 'F4.1', level: 'ORDINAL', label: 'make const not "var"'),
                   Variable.new(name: 'VAR1', format: 'A50', level: 'NOMINAL'),
                   Variable.new(name: 'VAR2', format: 'F15.5'),
                   Variable.new(name: 'VAR3', value_labels: { 1 => 'one', 2 => 'two' })]
    dataset = DataSet.new(variables)


    puts Benchmark.measure {
      1.upto(cases) do |i|
        values = [1, "привет\nмир", 2, 3]
        cas = Case.new(values)
        dataset << cas
      end
    }
    puts Benchmark.measure {
      export(dataset, '/home/oleg/Desktop/heeee.sav')
    }
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize

  def self.export(dataset, outfile)
    raise ArgumentError, "dataset must be DataSet, got #{dataset.class}" unless dataset.is_a?(DataSet)
    raise ArgumentError, "outfile must be String, got #{outfile.class}" unless outfile.is_a?(String)

    commands = dataset.to_pspp
    commands << "save outfile='#{outfile}'.\n"
    commands << 'finish.'

    datafile = Tempfile.new('pspp_data')
    datafile.binmode
    datafile << commands
    datafile.close

    pspp = Pspp.new
    pspp.execute(datafile.path)
  end
end
