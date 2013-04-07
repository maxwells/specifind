module Specifind

  module Comparators
    # Comparator holds the logic for each type of comparator that is use in {MethodBuilder} definition.
    #
    # The data are held in the class definition as [identifier (String), number of parameters (int), parameter suffixes (list of String), and sql creators (Procs)].
    class PostgreSQL < Base
      
      def self.comparators_data
        super + [
          ['_like',                 1, %w(_val),                      Proc.new{|v| "like #{v[0]}"}],
          ['_ilike',                1, %w(_val),                      Proc.new{|v| "ilike #{v[0]}"}]
        ]
      end
      
    end
  end
end
