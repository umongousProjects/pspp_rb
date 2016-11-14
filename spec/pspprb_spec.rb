require 'spec_helper'

describe PsppRb do
  it 'has a version number' do
    expect(PsppRb::VERSION).not_to be nil
  end

  describe 'export' do
    it 'generates correct dataset' do
      variables = [PsppRb::Variable.new(name: 'VAR0', format: 'F4.1', level: 'ORDINAL', label: 'make const not "var"'),
                   PsppRb::Variable.new(name: 'VAR1', format: 'A50', level: 'NOMINAL'),
                   PsppRb::Variable.new(name: 'VAR2', format: 'F9.4'),
                   PsppRb::Variable.new(name: 'VAR3', value_labels: { 1 => 'one', 2 => 'two' })]

      dataset = PsppRb::DataSet.new(variables)

      1.upto(15) do |i|
        values = [100 * i, 'text' * i, 200 * i, i % 2 + 1]
        cas = PsppRb::Case.new(values)
        dataset << cas
      end
      dataset << PsppRb::Case.new([1, "it's complicated", 2, 3])
      dataset << PsppRb::Case.new([1, 'its "very" complicated', 2, 3])
      dataset << PsppRb::Case.new([1, "it's \"very\" complicated", 2, 3])

      correct_output = <<-PSPP
data list list /VAR0(F4.1) VAR1(A50) VAR2(F9.4) VAR3.
variable level VAR0 (ORDINAL).
variable labels VAR0 'make const not "var"'.
variable level VAR1 (NOMINAL).
value labels /VAR3 1 'one' 2 'two'.
begin data.
100 'text' 200 2
200 'texttext' 400 1
300 'texttexttext' 600 2
400 'texttexttexttext' 800 1
500 'texttexttexttexttext' 1000 2
600 'texttexttexttexttexttext' 1200 1
700 'texttexttexttexttexttexttext' 1400 2
800 'texttexttexttexttexttexttexttext' 1600 1
900 'texttexttexttexttexttexttexttexttext' 1800 2
1000 'texttexttexttexttexttexttexttexttexttext' 2000 1
1100 'texttexttexttexttexttexttexttexttexttexttext' 2200 2
1200 'texttexttexttexttexttexttexttexttexttexttexttext' 2400 1
1300 'texttexttexttexttexttexttexttexttexttexttexttexttext' 2600 2
1400 'texttexttexttexttexttexttexttexttexttexttexttexttexttext' 2800 1
1500 'texttexttexttexttexttexttexttexttexttexttexttexttexttexttext' 3000 2
1 "it's complicated" 2 3
1 'its "very" complicated' 2 3
1 'it’s "very" complicated' 2 3
end data.
PSPP
      expect(dataset.to_pspp).to eq correct_output
    end
  end
end
