module Specifind

    # Operator holds the logic for each type of operator that is use in {MethodBuilder} definition.
  #
  # The data are held in the class definition as a list of identifying Strings.
  class Operator
    @@operators_data = %w(_and_ _or_)
    @@operators = []
    attr_accessor :pattern

    # list of operator objects
    def self.operators
      @@operators
    end

    # set list of operator objects
    def self.operators=(o)
      @@operators = o
    end

    # list of operator objects' patterns
    def self.patterns
      a = []
      @@operators.each{|c| a << c.pattern}
      a
    end

    # find an operator object based on identifying string
    def self.find(s)
      @@operators.each{|o| return o if o.pattern == s}
      nil
    end

    def initialize(args)
      @pattern = args[:pattern]
      Operator.operators << self
    end

    @@operators_data.each{|o| o = Operator.new pattern: o}
  end
end