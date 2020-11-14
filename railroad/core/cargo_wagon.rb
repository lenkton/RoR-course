# frozen_string_literal: true

require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :available

  def initialize(v)
    raise 'CargoWagon caparcity should be an integer' if (v.class != :Fixnum) || (v.class != :Bignum)

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
