# frozen_string_literal: true

require_relative 'meta_exception'

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
      instance_variable_set(type_sym, instance_variable_get(type_sym) || [] << [name, args])
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
      %i[@presence @format @type].each do |type|
        next unless (needs_validation = self.class.instance_variable_get(type))

        needs_validation.each do |entry|
          case type
          when :@presence then check_presence(entry[0])
          when :@format then check_format(entry[0], entry[1])
          when :@type then check_type(entry[0], entry[1])
          end
        end
      end
    end

    private

    def check_type(name, *args)
      raise MetaException, 'type checking needs a Class' unless args[0].is_a?(Class)

      unless instance_variable_get("@#{name}".to_sym).is_a?(args[0])
        raise MetaException, "#{name} is of incorrect class"
      end
    end

    def check_format(name, *args)
      raise MetaException, "#{name} is in incorrect format" unless args[0] =~ instance_variable_get("@#{name}".to_sym)
    end

    def check_presence(name)
      a = instance_variable_get("@#{name}".to_sym)
      raise MetaException, "#{name} is not present" unless a && a != ''
    end
  end
end
