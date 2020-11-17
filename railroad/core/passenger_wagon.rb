# frozen_string_literal: true

require_relative 'wagon'
require_relative 'railroad_exception'
require './meta/validation'

# PassengerWagon class
class PassengerWagon < Wagon
  include Validation

  attr_reader :seats_available

  validate :seats_total, Integer

  def initialize(name, seats)
    @seats_total = seats
    validate!
    
    @seats_available = @seats_total

    super(name)
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
