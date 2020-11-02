class Station
  attr_reader :trains
  def initialize(name)
    @name = name
    @trains = []
  end
  def add_train(train)
    @trains << train
  end
  def get_trains_by_type(type)
    #TODO
  end
  def send_train(train)
    @trains.delete train
  end
end
