# frozen_string_literal: true

require_relative 'meta_exception'

# accessors
module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # methods to extend a class
  module ClassMethods
    # to be used in children, but not outside the class

    protected

    def attr_accessor_with_history(*args)
      args.each do |arg|
        raise MetaException, 'attr_accessor_with_history requires symbols' unless arg.is_a?(Symbol)

        define_method(arg) do
          instance_variable_get("@#{arg}")
        end

        define_method("#{arg}=".to_sym) do |value|
          instance_variable_set("@#{arg}", value)
          hist = instance_variable_get("@#{arg}_history") || []
          instance_variable_set("@#{arg}_history", hist << value)
        end

        define_method("#{arg}_history".to_sym) do
          instance_variable_get("@#{arg}_history") || []
        end
      end
    end

    def strong_attr_accessor(name, type)
      raise MetaException, 'Second arg should be a Class' unless type.is_a?(Class)

      define_method(name) do
        instance_variable_get("@#{name}")
      end

      define_method("#{name}=".to_sym) do |value|
        raise MetaException, 'Wrong argument type' unless value.is_a?(type)

        instance_variable_set("@#{name}", value)
      end
    end
  end

  # methods to include in a class
  module InstanceMethods
  end
end
