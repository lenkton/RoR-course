# frozen_string_literal: true

# InstanceCounter module
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # methods to include in a class
  module ClassMethods
    def instances
      @instances ||= 0
    end

    def increase_instance_count
      @instances = instances + 1
    end
  end

  # methods to extend a class
  module InstanceMethods
    private

    def register_instance
      self.class.increase_instance_count
    end
  end
end
