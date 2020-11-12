# frozen_string_literal: true

require_relative 'producer'
require_relative 'instance_counter'

class Train
  include Producer
  include InstanceCounter

  attr_reader :current_station, :num, :route, :wagon_list
  attr_accessor :speed

  def self.find(number)
    @@trains.find { |tr| tr.num == number }
  end

  def valid?
    validate!(@num)
    true
  rescue StandardError
    false
  end

  def initialize(num)
    validate!(num)
    @wagon_list = []
    @num = num
    @speed = 0
    @@trains << self
    register_instance
  end

  def type; end

  # stops the Train
  def stop
    self.speed = 0
  end

  # adds one wagon, if the Train is stopped
  def add_wagon(wagon)
    @wagon_list << wagon if speed.zero? && wagon.type == type
  end

  # removes one wagon, if the Train is stopped
  def remove_wagon(wagon)
    @wagon_list.delete(wagon) if speed.zero?
  end

  def remove_last_wagon
    @wagon_list.pop if speed.zero?
  end

  # assigns the new route to the Train
  # and moves the Train to the first station of the new Route
  # (also, deletes the Train from the previous Station trains list
  # and adds to the new Station's list)
  def route=(route)
    @current_station&.send_train(self)

    @route = route
    @current_station = route.first
    @current_station.add_train(self)
  end

  # moves the Train to the next Station in the @route
  # does nothing, if the Train is already at the last Station of the @route
  def move_forward
    return if @current_station == @route.last

    @current_station.send_train(self)
    @current_station = next_station
    @current_station.add_train(self)
  end

  # moves the Train to the previous Station in the @route
  # does nothing, if the Train is already at the first Station of the @route
  def move_backward
    return if @current_station == @route.first

    @current_station.send_train(self)
    @current_station = previous_station
    @current_station.add_train(self)
  end

  # returns the previous station in the route
  def previous_station
    return @current_station if @current_station == @route.first

    @route.stations[@route.stations.index(@current_station) - 1]
  end

  # returns the next station in the route
  def next_station
    return @current_station if @current_station == @route.last

    @route.stations[@route.stations.index(@current_station) + 1]
  end

  private

  @@trains = []

  def validate!(num)
    raise 'Number of train cannot be nil' if num.nil?
    raise 'Incorrect train number format' if /^[a-z0-9]{3}(-[a-z0-9]{2})?$/i !~ num
    raise 'Basic Train cannot be instantiated' if type.nil?
  end
end
