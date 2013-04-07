module Specifind

  module Comparators
    # Comparator holds the logic for each type of comparator that is use in {MethodBuilder} definition.
    #
    # The data are held in the class definition as [identifier (String), number of parameters (int), parameter suffixes (list of String), and sql creators (Procs)].
    class Base
      class_attribute :comparators
      attr_accessor :pattern, :num_params, :param_suffixes, :values, :sql_proc

      self.comparators = []
      # list of comparator's patterns
      def self.patterns
        a = []
        self.comparators.each{|c| a << c.pattern}
        a
      end

      # find and return a (new) comparator by it's identifying string
      def self.find(s)
        self.comparators.each{|c| return c.clone if c.pattern == s}
        nil
      end

      def self.comparators_data
        [
          ['_in_list',              1, %w(_list),                     Proc.new{|v| "in (#{v[0]})"}],
          ['_less_than_equals',     1, %w(_val),                      Proc.new{|v| "<= #{v[0]}"}],
          ['_less_than',            1, %w(_val),                      Proc.new{|v| "< #{v[0]}"}],
          ['_greater_than_equals',  1, %w(_val),                      Proc.new{|v| ">= #{v[0]}"}],
          ['_greater_than',         1, %w(_val),                      Proc.new{|v| "> #{v[0]}"}],
          ['_not_equal',            1, %w(_val),                      Proc.new{|v| "!= #{v[0]}"}],
          ['_between',              2, %w(_bound_one _bound_two),     Proc.new{|v| "between #{v[0]} and #{v[1]}"}],
          ['_is_not_null',          0, [],                            Proc.new{|v| "is not null"}],
          ['_is_null',              0, [],                            Proc.new{|v| "is null"}],
          ['_equals',               1, %w(_val),                      Proc.new{|v| "= #{v[0]}"}]
        ]
      end

      # From the data listed in the Comparator class definition, Comparator.generate_comparators constructs each type of Comparators
      # and adds it to Comparator.comparators
      def self.generate_comparators
        self.comparators_data.each{|c| c = self.new :pattern => c[0], :num_params => c[1], :param_suffixes => c[2], :sql_proc => c[3] }
      end

      def initialize(args)
        @pattern = args[:pattern]
        @num_params = args[:num_params]
        @param_suffixes = @num_params > 0 ? args[:param_suffixes] : []
        @sql_proc = args[:sql_proc]
        @@encoding = ActiveRecord::Base.connection.instance_variable_get('@config')[:encoding]
        self.class.comparators += [self]
      end

      # Creates the values list for this comparator so that when it's build_sql method is called,
      # the sql building proc will know how to build the appropriate where clause
      def set_values(property_name, attribute_hash)
        @values = []
        param_suffixes.each{|s| @values << attribute_hash["#{property_name}#{s}".to_sym]} if num_params > 0
      end

      # builds sql (through @sql_proc) for values that corresponds with this type of comparator
      def to_where(name, remove_quotes = false)
        #raise 'values for comparator are not defined' if !values
        response = @sql_proc.call param_suffixes.map{|p| "\#{#{name}#{p}}" }
        response.delete! "'" if remove_quotes
        response
      end

      # builds signature (the parameter definitions for a method) based on the type of suffixes
      # that are required for this type of Comparator. See {AttributePhrase#to_signature} for further detail
      def to_signature(name)
        param_suffixes.map{|p| "#{name}#{p}" }.join(',')
      end

      # builds hash component (the parameters for the search_by method) based on the type of suffixes
      # that are required for this type of Comparator. See {AttributePhrase#to_params} for further detail
      def to_params(name)
        param_suffixes.map { |p| ":#{name}#{p} => #{name}#{p}" }.join(',')
      end

      def to_type_test(name, type)
        out = ""
        # assert that each variable associated with this comparator is of type passed.
        # if its not a list
        if @pattern != '_in_list'
          param_suffixes.each do |p|
            out += "#{name}#{p} = Type.assert_#{type}(#{name}#{p})\n"
          end
        else # is list - will only have one parameter, which is a list
          out += "#{name}#{param_suffixes[0]}.each do |v|
                    v = Type.assert_#{type}(v)
                  end"
        end
        out
      end

    end
  end
end
