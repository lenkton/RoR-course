# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'station'

# Route class
class Route
  include InstanceCounter

  attr_reader :first, :last, :number

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def initialize(first, last, number)
    @first = first
    @last = last
    @intermediate = []
    @number = number
    register_instance
  end

  # adds station to the route (at the position right before the end)
  def add_station(station)
    @intermediate << station
  end

  # removes the station from the @intermediate list
  def remove_station(station)
    return if station.trains.any? { |tr| tr.route == self }

    @intermediate.delete(station)
  end

  # returns the list of all stations in the route
  def stations
    [first, *@intermediate, last]
  end

  private

  def validate!
    raise 'Route number cannot be nil' if @number.nil?
    raise 'First station should be an instance of Station' if @first.class != :Station
    raise 'Second station should be an instance of Station' if @second.class != :Station
  end
end
