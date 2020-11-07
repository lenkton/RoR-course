require_relative 'train'
require_relative 'cargo_wagon'

class CargoTrain < Train
  def add_wagon(wagon)
    if wagon.instance_of?(CargoWagon)
      super(wagon)
    else
      puts 'Alarm! Wrong wagon type: CargoTrain needs CargoWagon'
    end
  end
end
