# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'railroad_exception'
require './meta/validation'

# Station class
class Station
  include InstanceCounter
  include Validation

  attr_reader :trains, :name

  validate :name, :presence

  def on_trains
    @trains.each { |tr| yield(tr) }
  end

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
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
