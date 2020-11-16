# frozen_string_literal: true

require_relative 'meta_exception'

# accessors
module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # methods to include in a class
  module ClassMethods
    def attr_accessor_with_history(*args)
      args.each do |arg|
        unless arg.is_a?(Symbol)
          raise MetaException, 'attr_accessor_with_history requires symbols'
        end

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
        unless value.is_a?(type)
          raise MetaException, 'Wrong argument type'
        end

        instance_variable_set("@#{name}", value)
      end
    end
  end

  # methods to extend a class
  module InstanceMethods
  end
end
