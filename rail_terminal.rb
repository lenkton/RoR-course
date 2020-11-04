# Ruby ver. 2.2.1
class Station 
  attr_reader :trains, :name

  def initialize(name) 
    @name = name 
    @trains = [] 
  end

  def add_train(train) 
    @trains << train 
  end

  # :pas - for passenger, :cargo - for cargo
  def get_trains_by_type(type)
    @trains.select { |tr| tr.type = type }
  end

  def send_train(train) 
    @trains.delete train 
  end 
end

class Route
  attr_reader :first, :last

  def initialize(first, last) 
    @first = first 
    @last = last
    @intermediate = [] 
    @versions = []
  end

  def add_station(station) 
    @intermediate.delete([station, :hidden])
    @intermediate << [station, :show]
  end

  # returns the next station in the route
  def next_station(station)
    if station == @last
      return @last
    end

    stats = self.stations

    if (pos = stats.index(station)) != nil
      return stats[pos + 1]
    end
    
    true_pos = @intermediate.index([station, :hidden])
    res = @intermediate.select { |elem| elem[1] == :show && @intermediate.index(elem) > true_pos }.first
    res ? res : @last
  end

  # returns the previous station in the route
  def previous_station(station)
    if station == @first
      return @first
    end

    stats = self.stations

    if (pos = stats.index(station)) != nil
      return stats[pos - 1]
    end

    true_pos = @intermediate.index([station, :hidden])
    res = @intermediate.select { |elem| elem[1] == :show && @intermediate.index(elem) < true_pos }.first
    res ? res : @first    
  end

  def remove_station(station) 
    @intermediate[@intermediate.index([station, :show])][1] = :hidden
  end

  def stations 
    [
      first, 
      *(@intermediate.select { |st| st[1] == :show } ),
      last
    ]
  end 
end

class Train 
  attr_reader :car_num, :current_station, :type, :num
  attr_accessor :speed

  def initialize(num, type, car_num) 
    @num = num 
    @type = type 
    @car_num = car_num
    @speed = 0 
    @route = nil 
  end

  def stop 
    self.speed = 0 
  end

  def add_car 
    @car_num += 1 if self.speed == 0 
  end

  def rem_car 
    @car_num -= 1 if self.speed == 0 
  end

  def route= (route) 
    if @current_station != nil
      @current_station.send_train(self)
    end

    @route = route 
    @current_station = route.first 
    @current_station.add_train(self)
  end

  def move_forward 
    return if @current_station == @route.last 
    @current_station.send_train(self)
    
    @current_station = @route.next_station(@cur_station)
    @current_station.add_train(self) 
  end

  def move_backward 
    return if @current_station == @route.first 
    @current_station.send_train(self)
    
    @current_station = @route.previous_station(@cur_station)
    @current_station.add_train(self)
  end

  def previous_station
    @route.previous_station(@cur_station)
  end

  def next_station
    @route.next_station(@cur_station)
  end
end
