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
    @trains.select { |tr| tr.type == type }
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
  end

  # adds station to the route (at the position right before the end)
  def add_station(station)
    @intermediate << station
  end

  # removes the station from the @intermediate list
  def remove_station(station)
    if station.trains.any? { |tr| tr.route == self }
      puts "Alarm! Alarm! Some trains at #{station} could get lost!"
      return
    end

    @intermediate.delete(station)
  end

  #returns the list of all stations in the route
  def stations
    [first, *@intermediate, last]
  end
end

class Train
  attr_reader :car_num, :current_station, :type, :num, :route
  attr_accessor :speed

  def initialize(num, type, car_num)
    @num = num
    @type = type
    @car_num = car_num
    @speed = 0
  end

  # stops the Train
  def stop
    self.speed = 0
  end

  # adds one cargo, if the Train is stopped
  def add_car
    @car_num += 1 if speed.zero?
  end

  # removes one cargo, if the Train is stopped
  def rem_car
    @car_num -= 1 if speed.zero?
  end

  # assigns the new route to the Train
  # and moves the Train to the first station of the new Route
  # (also, deletes the Train from the previous Station trains list
  # and adds to the new Station's list)
  def route=(route)
    @current_station.send_train(self) unless @current_station

    @route = route
    @current_station = route.first
    @current_station.add_train(self)
  end

  # moves the Train to the next Station in the @route
  # does nothing, if the Train is already at the last Station of the @route
  def move_forward
    return if @current_station == @route.last

    @current_station.send_train(self)
    @current_station = next_station
    @current_station.add_train(self)
  end

  # moves the Train to the previous Station in the @route
  # does nothing, if the Train is already at the first Station of the @route
  def move_backward
    return if @current_station == @route.first

    @current_station.send_train(self)
    @current_station = previous_station
    @current_station.add_train(self)
  end

  # returns the previous station in the route
  def previous_station
    return @current_station if @current_station == @route.first

    return @route.stations[@route.stations.index(@current_station) - 1]
  end

  # returns the next station in the route
  def next_station
    return @current_station if @current_station == @route.last

    return @route.stations[@route.stations.index(@current_station) + 1]
  end
end
