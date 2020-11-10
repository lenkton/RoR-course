# frozen_string_literal: true

class Route
  attr_reader :first, :last, :number

  def initialize(first, last, number)
    @first = first
    @last = last
    @intermediate = []
    @number = number
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
