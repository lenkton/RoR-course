# frozen_string_literal: true

require_relative 'wagon'
require_relative 'railroad_exception'

# PassengerWagon class
class PassengerWagon < Wagon
  attr_reader :seats_available

  def initialize(name, seats)
    raise RailroadException, 'Seats should be of type Integer' unless seats.is_a?(Integer)

    super(name)
    @seats_total = seats
    @seats_available = seats
  end

  def take_seat
    raise RailroadException, 'No available seats' if @seats_available.zero?

    @seats_available -= 1
  end

  def seats_taken
    @seats_total - @seats_available
  end

  def type
    :passenger
  end
end
