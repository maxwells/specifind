#require 'active_record'

module Specifind
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :MethodBuilder
  autoload :Comparators
  autoload :Operator
  autoload :AttributePhrase
  autoload :Type

  included do
    Specifind::Comparators.generate_comparators
    Type.generate_methods
  end

  module ClassMethods

    def method_missing(name, *arguments, &block)
      unless Specifind.comparator
        active_record_adapter = ActiveRecord::Base.connection.class.name.split(':').last.gsub /Adapter/, ''
        comparator = "Specifind::Comparators::#{active_record_adapter}".constantize
        Specifind.comparator = "Specifind::Comparators::#{active_record_adapter}".constantize
      end
      
      match = MethodBuilder.match(self, name)
      if match && match.valid?
        types = self.columns.map{|c| {name:c.name, type:c.type}}
        match.merge_attribute_types types
        match.define
        send(name, *arguments, &block)
      else
        super
      end
    end
  end

  def self.comparator=(val)
    @comparator = val
  end

  def self.comparator
    @comparator
  end

end

ActiveRecord::Base.send(:include, Specifind)