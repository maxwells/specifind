module Specifind

  ##
  # The AttributePhrase class is a component of the {MethodBuilder} -> {QueryBuilder} -> SQL flow. See {MethodBuilder}
  # for more detail on how that works. AttributePhrase objects have search parameters specific to the attribute
  # (ie. name of attribute and value(s) associated with it), sometimes a {Comparator} (specifying how to query
  # those attributes in relation to the provided values), and sometimes an {Operator} (specifying how to link)
  # this attribute in the query to the next attribute (ie. 'and', 'or').
  #
  # Example AttributePhrase:
  # - name: :first_name
  # - type: :varchar
  # - value: 'Steve'
  # - comparator: Comparator matching 'equals'
  # - operator: Operator matching 'and'
  #
  # will be used by the QueryBuilder, as delegated by MethodBuilder to construct a sql fragment that will find
  # object ids that have a first_name property equal to 'Steve' and link it with whatever AttributePhrase follows
  # with an and Operator.
  #
  class AttributePhrase
    attr_accessor :name, :value, :type, :comparator, :operator

    ##
    # Class factory method to build AttributePhrase objects from a String (which contains an attribute name and sometimes a comparator) and an Operator object.
    # If no comparator is included in the string, it is assumed to mean equals. If no operator is included in the args, then the AttributePhrase is assumed
    # to be the terminal part of the query
    #
    # @param [Hash] args requires [:string] and [:operator]. String is of form 'attribute(_comparator)' and operator is of type Operator or nil
    def self.from_string_and_operator(args)
      raise 'AttributePhrase.from_string_and_operator requires a hash with [:string]' unless args[:string]
      comparator_patterns = Regexp.new Specifind.comparator.patterns.map{|c| c = "(#{c})"}.join '|'
      attribute_with_comparator = args[:string].split comparator_patterns
      name = attribute_with_comparator[0]
      comparator = attribute_with_comparator[1] || '_equals'
      AttributePhrase.new name: name, comparator: comparator, operator: args[:operator]
    end

    ##
    # A new instance of AttributePhrase
    #
    # @param [Hash] args requires [:name], specifying the name of the class's attribute that is being searched on. Can also take [:type], which will
    # set the type of the object to any of (:boolean, :varchar, :datetime, :num). Can take [:value], which sets the value(s) to be queried (per the
    # terms of the comparator). Can take [:comparator] and [:operator]. These values can also be set after creation time but before query building
    # in case the values are not known by the instantiating object
    def initialize(args)
      @name = args[:name]
      @type = args[:type] || nil
      @value = args[:value] || nil
      @comparator = Specifind.comparator.find(args[:comparator]) || nil
      @operator = Operator.find(args[:operator]) || nil
    end

    def build_comparator_sql
      comparator.build_sql
    end

    ##
    # Constructs a constructor call for this AttributePhrase object.
    #
    # Used in a special case by MethodBuilder, which needs to create a block of code (dynamically) to match the method passed. As such,
    # we cannot pass a pointer to the object, so this method dehydrates it with directions for recreating itself.
    def to_where

      ".where(\"#{@name} #{@comparator.to_where(@name, @type == :boolean)}\")"
    end

    ##
    # Converts this attribute to the parameters it requires (based on it's {Comparator}) for {MethodBuilder}.
    #
    # Example:
    # An AttributePhrase object first_name equals 'Steve' will generate it's portion of the magic method signature
    # search_by_first_name_equals(first_name_val), where first_name_val is the signature
    #
    # An AttributePhrase object with age between 15 and 25 will generate it's portion of the magic method signature
    # search_by_age_between(age_bound_one, age_bound_two), where age_bound_one, age_bound_two is it's signature
    def to_signature
      @comparator ? @comparator.to_signature(@name) : nil
    end

    ##
    # Converts this attribute to the parameters that the search_by method in the Searchable concern takes
    # and passes to QueryBuilder
    def to_params
      @comparator ? @comparator.to_params(@name) : nil
    end

    def to_assertion
      @comparator.to_type_test @name, @type
    end

    ##
    # rearrange any parameter thats passed to necessary values
    #
    # example: sql lists are formatted as (val1, val2, val3), while ruby will export (strings) as ['val1', 'val2', 'val3']
    def to_rearrangement
      @comparator.to_rearrangement @name, @type
    end

  end
end