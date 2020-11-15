# frozen_string_literal: true

require_relative 'wagon'
require_relative 'railroad_exception'

# CargoWagon class
class CargoWagon < Wagon
  attr_reader :available

  def initialize(num, total_capacity)
    raise RailroadException, 'CargoWagon caparcity should be an integer' unless total_capacity.is_a?(Integer)

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
