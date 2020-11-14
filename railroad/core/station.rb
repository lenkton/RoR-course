# frozen_string_literal: true

require_relative 'instance_counter'

# Station class
class Station
  include InstanceCounter

  attr_reader :trains, :name

  def on_trains(&block)
    @trains.each(&block)
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
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

  private

  def validate!
    raise 'The name of a Station cannot be nil' if @name.nil?
  end

  @@stations = []
end
