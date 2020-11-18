# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'station'
require_relative 'railroad_exception'
require './meta/validation'

# Route class
class Route
  include InstanceCounter
  include Validation

  attr_reader :first, :last, :number

  validate :number, :presence
  validate :first, :type, Station
  validate :last, :type, Station

  def initialize(first, last, number)
    @first = first
    @last = last
    @number = number
    validate!
    @intermediate = []
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
end
