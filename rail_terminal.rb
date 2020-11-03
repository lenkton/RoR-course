class Station 
  attr_reader :trains

  def initialize(name) 
    @name = name @trains = [] 
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

class Route def initialize(first, last) 
  @first = first 
  @last = last
  @intermediate = [] 
end

  def add_station(station) 
    @intermediate << station 
  end

  def remove_station(station) 
    @intermediate.delete(station) 
  end

  def get_stations 
    res = [first] 
    res += @intermediate 
    res << last 
  end 
end

class Train 
  attr_reader :car_num 
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
    @route = route 
    @cur_station = route.first 
  end

  # issue: the @cur_station could be deleted from the @route...
  def move_forward 
    if @cur_station != @route.last 
      stats = @route.get_stations
      @cur_station.send_train(self)
    
      @cur_station = stats[stats.index(@cur_station) + 1]
      @cur_station.add_train(self) 
    end 
  end

  def move_backward 

  end
end
