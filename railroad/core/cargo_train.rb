# frozen_string_literal: true

require_relative 'train'
require_relative 'cargo_wagon'

# CargoTrain class
class CargoTrain < Train
  def type
    :cargo
  end
end
