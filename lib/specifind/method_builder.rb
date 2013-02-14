
module Specifind

  class MethodBuilder
    @matchers = []

    class << self
      attr_reader :matchers

      def match(model, name)
        klass = matchers.find { |k| name =~ k.pattern }
        klass.new(model, name) if klass
      end

      def parse_to_attributes(s)
        operator_regexp = Regexp.new Operator.patterns.map{|s| s = "(#{s})"}.join '|'
        hybrid_list = s.split(operator_regexp)
        attribute_list = []
        # it is now split into [field_name (+comparator)] + operator + [field_name (+comparator)] ...

        attribute_list << AttributePhrase.from_string_and_operator(string: hybrid_list.shift, operator: hybrid_list.shift) while hybrid_list.length > 0
        attribute_list
      end

      def pattern
        /^#{prefix}_([_a-zA-Z]\w*)#{suffix}$/
      end

      def prefix
        raise NotImplementedError
      end

      def suffix
        ''
      end
    end

    attr_reader :model, :name, :attribute_names, :attributes

    def initialize(model, name)
      @model           = model
      @name            = name.to_s
      match = @name.match(self.class.pattern)
      @attributes      = MethodBuilder.parse_to_attributes match[1]
      puts @attributes.to_json
      @attribute_names = @attributes.map{ |a| a.name }
    end

    def merge_attribute_types(columns)
      @attributes.each do |a|
        columns.each do |c|
          if a.name == c[:name]
            a.type = c[:type]
          end
        end
      end
    end

    def valid?
      attribute_names.all? { |name| model.columns_hash[name] || model.reflect_on_aggregation(name.to_sym) }
    end

    def define
      assertions = ""
      @attributes.each do |a|
        assertions += a.to_assertion
      end
      puts "def self.#{name}(#{signature})
          #{assertions}
          #{body}
        end"
      model.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def self.#{name}(#{signature})
          #{assertions}
          #{body}
        end
      CODE
    end

    def body
      raise NotImplementedError
    end
  end

  module Finder
    # Extended in activerecord-deprecated_finders
    def body
      result
    end

    # Extended in activerecord-deprecated_finders
    def result
      s = "#{model.name}"
      @attributes.each do |a|
        s += "#{a.to_where}"
      end
      s
    end

    # Extended in activerecord-deprecated_finders
    def signature
      attributes.map{|a| a.to_signature }.delete_if{|s| s == nil}.join(', ')
    end

    def attributes_hash
      "{" + attribute_names.map { |name| ":#{name} => #{name}" }.join(',') + "}"
    end

    def finder
      raise NotImplementedError
    end
  end

  class FindBy < MethodBuilder
    MethodBuilder.matchers << self
    include Finder

    def self.prefix
      "find_by"
    end

    def finder
      "find_by"
    end
  end

  class FindByBang < MethodBuilder
    MethodBuilder.matchers << self
    include Finder

    def self.prefix
      "find_by"
    end

    def self.suffix
      "!"
    end

    def finder
      "find_by!"
    end
  end

end