module PsppRb
  class DataSet
    include Enumerable

    attr_reader :variables, :cases

    def initialize(variables)
      self.variables = variables
      self.cases = []
    end

    def append_case(cas)
      raise ArgumentError, "case must be Case, got #{cas.class}" unless cas.is_a?(Case)
      cases << cas
    end

    def <<(cas)
      append_case(cas)
    end

    def each
      cases.each { |c| yield c }
    end

    def to_pspp
      # NOTE the data can be large, so it's important to mutate single string
      data = to_pspp_definition
      variables.each do |var|
        data << var.to_pspp
      end
      data << "begin data.\n"
      data << to_pspp_data
      data << "end data.\n"
      data
    end

    def to_pspp_definition(file = nil)
      file_def = file ? " file='#{file}'" : ''
      "data list#{file_def} list /#{variables.map(&:to_pspp_definition).join(' ')}.\n"
    end

    def to_pspp_data
      data = ''
      each do |c|
        data << c.to_pspp
      end
      data
    end

    private

    attr_writer :variables, :cases
  end
end
