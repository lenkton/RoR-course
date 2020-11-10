module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.send(:instances=, 0)
  end

  module ClassMethods
    public
    attr_reader :instances
    private
    attr_writer :instances
  end

  module InstanceMethods
    #Does not even pretend to work
    @instances = 0

    private

    def register_instance
      #unless self.class.instances
       # self.class.send(:instances=, 0)
      #end

      self.class.send(:instances=,  self.class.instances + 1)
    end
  end
end

