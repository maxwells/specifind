#require 'active_record'

module Specifind
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :MethodBuilder
  autoload :Comparator
  autoload :Operator
  autoload :AttributePhrase

  included do
    Comparator.generate_comparators
  end

  module ClassMethods

    def method_missing(name, *arguments, &block)
      match = MethodBuilder.match(self, name)
      if match && match.valid?
       # match.merge_attributes_values
        match.define
        ##merged_attributes = MethodBuilder.merge_attributes_values attribute_phrases, attribute_values
        send(name, *arguments, &block)
      else
        super
      end
    end



  end

end
