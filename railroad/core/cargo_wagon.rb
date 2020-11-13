# frozen_string_literal: true

require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :available

  def initialize(v)
    if v.class != :Fixnum or v.class != :Bignum
      raise "CargoWagon caparcity should be an integer"
    end

    @capacity = v
    @available = v
  end

  def occupy(v)
    raise "Volume exceeds available capacity" if v > @available
    
    @available -= v
  end

  def occupied
    @capacity - @available
  end

  def type
    :cargo
  end
end
