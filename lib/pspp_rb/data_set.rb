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
      each do |c|
        data << c.to_pspp
      end
      data << "end data.\n"
      data
    end

    private

    attr_writer :variables, :cases

    def to_pspp_definition
      "data list list /#{variables.map(&:to_pspp_definition).join(' ')}.\n"
    end
  end
end
