# frozen_string_literal: true

require_relative 'train'
require_relative 'passenger_wagon'

class PassengerTrain < Train
  def add_wagon(wagon)
    if wagon.instance_of?(PassengerWagon)
      super(wagon)
    else
      puts 'Alarm! Wrong wagon type: PassengerTrain needs PassengerWagon'
    end
  end
end
