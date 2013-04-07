module Specifind

  # Comparator holds the logic for each type of comparator that is use in {MethodBuilder} definition.
  #
  # The data are held in the class definition as [identifier (String), number of parameters (int), parameter suffixes (list of String), and sql creators (Procs)].
  module Comparators
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :SQLite3
    autoload :Mysql2
    autoload :PostgreSQL

    def self.generate_comparators
      SQLite3.generate_comparators
      Mysql2.generate_comparators
      PostgreSQL.generate_comparators
    end

  end
end
