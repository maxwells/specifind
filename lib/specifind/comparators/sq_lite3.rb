module Specifind

  module Comparators
    # Comparator holds the logic for each type of comparator that is use in {MethodBuilder} definition.
    #
    # The data are held in the class definition as [identifier (String), number of parameters (int), parameter suffixes (list of String), and sql creators (Procs)].
    class SQLite3 < Base

      def self.comparators_data
        super + [
          ['_like',                 1, %w(_val),                      Proc.new{|v| "like #{v[0]}"}],
          ['_ilike',                1, %w(_val),                      Proc.new{|v| "like #{v[0]}"}]
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
