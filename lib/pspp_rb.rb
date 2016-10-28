require 'pspp_rb/version'
require 'pspp_rb/pspp'
require 'pspp_rb/list'
require 'pspp_rb/row'
require 'pspp_rb/variable'
require 'pspp_rb/cell'
require 'pspp_rb/pspp_error'

module PsppRb
  def self.dummy
    variables = [Variable.new(name: 'var_0', format: 'F4.1', level: 'NOMINAL'),
                 Variable.new(name: 'var_1', format: 'A30', level: 'NOMINAL'),
                 Variable.new(name: 'var_2', format: 'F9.4', level: 'NOMINAL')]
    list = List.new(variables)
    1.upto(15) do |i|
      cell0 = Cell.new(3.0 * i)
      cell1 = Cell.new('ПРЕВЕД' * i)
      cell2 = Cell.new(50.0 * i)
      row = Row.new
      row << cell0
      row << cell1
      row << cell2
      list << row
    end

    pspp = Pspp.new
    puts pspp.export(list, '/home/oleg/Desktop/hello.sav')

    puts '******'
    puts pspp.log

    puts "&&&&&&& errors: "
    puts pspp.errors
  end
end
