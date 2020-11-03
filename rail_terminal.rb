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

class Route 
  def initialize(first, last) 
    @first = first 
    @last = last
    @intermediate = [] 
  end

  def add_station(station) 
    @intermediate << station 
  end

  # returns the next station in the route
  def forw(station)
    if station == @last
      @last
    else
      stats = self.get_stations

      stats[stats.index(station) + 1]
    end
  end

  # returns the previous station in the route
  def back(station)
    if station == @first
      @first
    else
      stats = self.get_stations

      stats[stats.index(station) - 1]
    end
  end

  def remove_station(station) 
    for tr in station.trains
      tr.prev_station = back(station) if tr.prev_station = station
      tr.next_station = forw(station) if tr.next_station = station
    end
    @intermediate.delete(station) 
  end

  def get_stations 
    res = [first] 
    res += @intermediate 
    res << last 
  end 
end

class Train 
  # issue: incapsulation is dead, needs reworking
  attr_reader :car_num, :cur_station 
  attr_accessor :speed, :prev_station, :next_station

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
    @prev_station = route.first
    @next_station = route.forw(route.first)
  end

  def move_forward 
    if @cur_station != @route.last 
      @cur_station.send_train(self)
    
      @cur_station = self.next_station
      @cur_station.add_train(self) 

      self.prev_station = @route.back(self.cur_station)
      self.next_station = @route.forw(self.cur_station)
    end 
  end

  def move_backward 
    if @cur_station != @route.first 
      @cur_station.send_train(self)
    
      @cur_station = self.prev_station
      @cur_station.add_train(self)

      self.prev_station = @route.back(self.cur_station)
      self.next_station = @route.forw(self.cur_station)
    end
  end
end
