module Specifind
  class Type

    def self.data
      [
        { type: 'binary', allowed_classes: [String] },
        { type: 'boolean', allowed_classes: [TrueClass, FalseClass] },
        { type: 'date', allowed_classes: [Date, DateTime] },
        { type: 'decimal', allowed_classes: [Float, Fixnum] },
        { type: 'float', allowed_classes: [Float] },
        { type: 'integer', allowed_classes: [Fixnum] },
        { type: 'string', allowed_classes: [String] },
        { type: 'text', allowed_classes: [String] },
        { type: 'time', allowed_classes: [Time] },
        { type: 'timestamp', allowed_classes: [Date, DateTime] }
      ]
    end

    def self.generate_methods
      self.data.each do |h|
        names = h[:allowed_classes].map{|c| c.name}.join ' or '
        types = h[:allowed_classes].map{|c| "val.kind_of? #{c.name}"}.join ' or '
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def self.assert_#{h[:type]}(val)
            raise "Dynamic finder required #{names}, \#{val.class} provided" unless #{types}
            escape_values(val)
          end
        CODE
      end
    end

    def self.escape_values(val)
      c = ActiveRecord::Base.connection
      c.quote(val)
    end

  end
end