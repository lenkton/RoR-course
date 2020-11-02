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

class Route
  def initialize(first, last)
    @first = first
    @last = last
    @intermediate = []
  end
  def add_station(station)
    @intermediate << station
  end
  def remove_station(station)
    @intermediate.delete station
  end
  def get_stations
    res = [first]
    res += @intermediate
    res << last
  end
end
