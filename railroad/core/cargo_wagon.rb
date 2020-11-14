# frozen_string_literal: true

require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :available

  def initialize(num, v)
    raise 'CargoWagon caparcity should be an integer' unless v.is_a?(Integer) || v.is_a?(Integer)

    super(num)
    @capacity = v
    @available = v
  end

  def occupy(v)
    raise 'Volume exceeds available capacity' if v > @available

    @available -= v
  end

  def occupied
    @capacity - @available
  end

  def type
    :cargo
  end
end
