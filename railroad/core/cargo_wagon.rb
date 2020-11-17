# frozen_string_literal: true

require_relative 'wagon'
require_relative 'railroad_exception'
require './meta/validation'

# CargoWagon class
class CargoWagon < Wagon
  include Validation

  attr_reader :available

  validate :total_capacity, Integer

  def initialize(num, total_capacity)

    validate!
    super(num)
    @capacity = total_capacity
    @available = total_capacity
  end

  def occupy(capacity)
    raise RailroadException, 'Volume exceeds available capacity' if capacity > @available

    @available -= capacity
  end

  def occupied
    @capacity - @available
  end

  def type
    :cargo
  end
end
