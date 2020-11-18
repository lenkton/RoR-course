# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_wagon'
require './meta/validation'

# CargoTrain class
class CargoTrain < Train
  validate :num, :presence
  validate :num, :format, /^[a-z0-9]{3}(-[a-z0-9]{2})?$/i

  def type
    :cargo
  end
end
