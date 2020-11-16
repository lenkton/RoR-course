# frozen_string_literal: true

require_relative 'train'
require_relative 'passenger_wagon'

# PassengerTrain class
class PassengerTrain < Train
  def type
    :passenger
  end
end
