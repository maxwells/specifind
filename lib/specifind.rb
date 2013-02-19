#require 'active_record'

module Specifind
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :MethodBuilder
  autoload :Comparator
  autoload :Operator
  autoload :AttributePhrase
  autoload :Type

  included do
    Comparator.generate_comparators
    Type.generate_methods
  end

  module ClassMethods
    def acts_as_findable
      self.send :include, SpecifindWorkings
    end
  end

  module SpecifindWorkings
    extend ActiveSupport::Concern

    module ClassMethods
      def method_missing(name, *arguments, &block)
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
  end

end

ActiveRecord::Base.send(:include, Specifind)