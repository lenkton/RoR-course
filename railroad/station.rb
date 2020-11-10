# frozen_string_literal: true

require_relative 'instance_counter'

# Ruby ver. 2.2.1
class Station
  include InstanceCounter

  attr_reader :trains, :name

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
  end

  def add_train(train)
    @trains << train
  end

  # :pas - for passenger, :cargo - for cargo
  def get_trains_by_type(type)
    @trains.select { |tr| tr.type == type }
  end

  def send_train(train)
    @trains.delete train
  end

  @@stations = []
end
