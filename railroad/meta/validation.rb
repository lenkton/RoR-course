# frozen_string_literal: true

require_relative 'meta_exception'
require 'set'

# validation module
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # methods to extend a class
  module ClassMethods
    # to be used in children, but not outside the class

    protected

    def validate(name, type, *args)
      [name, type].each do |arg|
        raise MetaException, "#{arg} is not a symbol" unless arg.is_a?(Symbol)
      end

      type_sym = "@#{type}".to_sym
      instance_variable_set(
        type_sym,
        (instance_variable_get(type_sym) || []) << [name, args]
      )
      instance_variable_set(
        '@to_validate',
        (instance_variable_get('@to_validate') || Set[]) << type # note: 'type' is passed
      )
    end
  end

  # methods to include in a class
  module InstanceMethods
    def valid?
      validate!
      true
    rescue MetaException
      false
    end

    protected

    def validate!
      return unless (validation_types = self.class.instance_variable_get('@to_validate'))

      validation_types.each do |type|
        next unless (needs_validation = self.class.instance_variable_get("@#{type}".to_sym))

        needs_validation.each do |entry|
          send(type, *entry)
        end
      end
    end

    private

    def type(name, args)
      raise MetaException, 'type checking needs a Class' unless args[0].is_a?(Class)

      unless instance_variable_get("@#{name}").is_a?(args[0])
        raise MetaException, "#{name} is of incorrect class"
      end
    end

    def format(name, args)
      raise MetaException, "#{name} is in incorrect format" if instance_variable_get("@#{name}".to_sym) !~ args[0]
    end

    def presence(name, *)
      a = instance_variable_get("@#{name}".to_sym)
      raise MetaException, "#{name} is not present" unless a && a != ''
    end
  end
end
