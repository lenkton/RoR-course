# frozen_string_literal: true

require_relative 'train'
require_relative 'passenger_wagon'
require './meta/validation'

# PassengerTrain class
class PassengerTrain < Train
  validate :num, :presence
  validate :num, :format, /^[a-z0-9]{3}(-[a-z0-9]{2})?$/i

  def type
    :passenger
  end
end
