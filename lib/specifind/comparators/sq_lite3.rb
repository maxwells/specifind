module Specifind

  module Comparators
    # Comparator holds the logic for each type of comparator that is use in {MethodBuilder} definition.
    #
    # The data are held in the class definition as [identifier (String), number of parameters (int), parameter suffixes (list of String), and sql creators (Procs)].
    class SQLite3 < Base

      def self.comparators_data
        [
          ['_in_list',              1, %w(_list),                     Proc.new{|v| "in (#{v[0]})"}],
          ['_less_than_equals',     1, %w(_val),                      Proc.new{|v| "<= #{v[0]}"}],
          ['_less_than',            1, %w(_val),                      Proc.new{|v| "< #{v[0]}"}],
          ['_greater_than_equals',  1, %w(_val),                      Proc.new{|v| ">= #{v[0]}"}],
          ['_greater_than',         1, %w(_val),                      Proc.new{|v| "> #{v[0]}"}],
          ['_like',                 1, %w(_val),                      Proc.new{|v| "like #{v[0]}"}],
          ['_ilike',                1, %w(_val),                      Proc.new{|v| "like #{v[0]}"}],
          ['_not_equal',            1, %w(_val),                      Proc.new{|v| "!= #{v[0]}"}],
          ['_between',              2, %w(_bound_one _bound_two),     Proc.new{|v| "between #{v[0]} and #{v[1]}"}],
          ['_is_not_null',          0, [],                            Proc.new{|v| "is not null"}],
          ['_is_null',              0, [],                            Proc.new{|v| "is null"}],
          ['_equals',               1, %w(_val),                      Proc.new{|v| "= #{v[0]}"}]
        ]
      end

      def to_rearrangement(name, type)
        out = ''
        if @pattern == '_in_list'
          out += "#{name}#{param_suffixes[0]} = #{name}#{param_suffixes[0]}.map{|el| '\"'+el+'\"'}.join ','"
        end
        out
      end
    end
  end
end
