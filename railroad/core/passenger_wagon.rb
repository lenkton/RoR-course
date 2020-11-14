# frozen_string_literal: true

require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :seats_available

  def initialize(seats)
    raise 'Seats should be of type Fixnum (or Bignum)' if seats.class != :Fixnum || seats.class != :Bignum

    @seats_total = seats
    @seats_available = seats
  end

  def take_seat
    raise 'No available seats' if @seats_available == 0

    @seats_available -= 1
  end

  def seats_taken
    @seats_total - @seats_available
  end

  def type
    :passenger
  end
end
