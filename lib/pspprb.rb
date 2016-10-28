require 'pspprb/version'
require 'pspprb/pspp'
require 'pspprb/table'
require 'pspprb/row'
require 'pspprb/variable'
require 'pspprb/cell'
require 'pspprb/pspp_error'

module Pspprb
  def self.dummy
    variables = [Variable.new('var_0', Variable::Type.new('F4.1')),
                 Variable.new('var_1', Variable::Type.new('A20')),
                 Variable.new('var_2', Variable::Type.new('F9.4'))]
    table = Table.new(variables)
    1.upto(15) do |i|
      cell0 = Cell.new(3.0 * i)
      cell1 = Cell.new('F' * i)
      cell2 = Cell.new(50.0 * i)
      row = Row.new
      row << cell0
      row << cell1
      row << cell2
      table << row
    end

    pspp = Pspp.new('/home/oleg/Desktop/hello.sav', table)
    puts pspp.export

    puts '******'
    puts pspp.log

    puts "&&&&&&& errors: "
    puts pspp.errors
  end
end
