module Specifind
  class Type

    def self.escape_values(val)
      c = ActiveRecord::Base.connection
      c.quote(val)
    end

    def self.assert_binary(val)
      raise "Dynamic finder required String, #{val.class} provided" unless val.kind_of? String
      escape_values(val)
    end

    def self.assert_boolean(val)
      raise "Dynamic finder required Boolean (TrueClass), #{val.class} provided" unless val.kind_of? TrueClass or val.kind_of? FalseClass
      escape_values(val)
    end

    def self.assert_date(val)
      raise "Dynamic finder required Date, #{val.class} provided" unless (val.kind_of? Date or val.kind_of? DateTime)
      escape_values(val)
    end

    def self.assert_datetime(val)
      raise "Dynamic finder required DateTime, #{val.class} provided" unless (val.kind_of? Date or val.kind_of? DateTime)
      escape_values(val)
    end

    def self.assert_decimal(val)
      raise "Dynamic finder required Decimal (Float), #{val.class} provided" unless val.kind_of? Float
      escape_values(val)
    end

    def self.assert_float(val)
      raise "Dynamic finder required Float, #{val.class} provided" unless val.kind_of? Float
      escape_values(val)
    end

    def self.assert_integer(val)
      raise "Dynamic finder required Fixnum (Integer), #{val.class} provided" unless val.kind_of? Fixnum
      escape_values(val)
    end

    def self.assert_string(val)
      raise "Dynamic finder required String, #{val.class} provided" unless val.kind_of? String
      escape_values(val)
    end

    def self.assert_text(val)
      raise "Dynamic finder required String, #{val.class} provided" unless val.kind_of? String
      escape_values(val)
    end

    def self.assert_time(val)
      raise "Dynamic finder required Time, #{val.class} provided" unless val.kind_of? Time
      escape_values(val)
    end

    def self.assert_timestamp(val)
      raise "Dynamic finder required Timestamp (DateTime), #{val.class} provided" unless (val.kind_of? Date or val.kind_of? DateTime)
      escape_values(val)
    end

  end
end