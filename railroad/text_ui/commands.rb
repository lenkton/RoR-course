# frozen_string_literal: true

# module with nearly all commands
module Commands
  protected

  def add_station(args)
    check_form!(args, %i[station route])

    @routes[args[1]].add_station(@stations[args[0]])
    puts "Station #{args[0]} was successfully added to the Route #{args[1]}"
  end

  def remove_station(args)
    check_form!(args, %i[station route])

    @routes[args[1]].remove_station(@stations[args[0]])
    puts "Station #{args[0]} was successfully removed from the Route #{args[1]}"
  end

  def add_wagon(args)
    check_form!(args, %i[train any any])

    raise "A wagon with the name #{args[1]} already exist" if @wagons.include?(args[1])

    num = args[2].to_i

    case @trains[args[0]].type
    when :passenger
      wagon = PassengerWagon.new(args[1], num)
      @trains[args[0]].add_wagon(wagon)
    when :cargo
      wagon = CargoWagon.new(args[1], num)
      @trains[args[0]].add_wagon(wagon)
    else
      raise TypeError, "Wrong class of train #{args[0]}"
    end

    @wagons[args[1]] = wagon

    puts "A #{wagon.class} was successfully added to the Train #{args[0]}"
  end

  def remove_wagon(args)
    check_form!(args, [:train])

    @trains[args[0]].remove_last_wagon
    puts "A wagon was successfully removed from the Train #{args[0]}"
  end

  def stations
    puts 'At the moment these stations were created:'
    @stations.each do |_name, _st|
      puts _name
    end
  end

  def assign(args)
    check_form!(args, %i[route train])

    @trains[args[1]].route = @routes[args[0]]
    puts "The Route #{args[0]} was successfully assigned to the Train #{args[1]}"
  end

  def trains(args)
    check_form!(args, [:station])

    puts "At the moment these Trains are at the Station #{args[0]}:"
    @stations[args[0]].on_trains do |tr|
      puts tr.num, tr.type, tr.wagon_list.size
    end
  end

  def wagons(args)
    check_form!(args, [:train])

    puts "At the moment the Train #{args[0]} has the following Wagons attached:"
    @trains[args[0]].on_wagons do |w|
      puts w.num, w.type
      case w.type
      when :passenger
        puts "Seats available: #{w.seats_available}"
        puts "Seats taken: #{w.seats_taken}"
      when :cargo
        puts "Available capacity: #{w.available}"
        puts "Occupied capacity: #{w.occupied}"
      else raise "Wrong type of the Train #{w.num}"
      end
    end
  end

  def move(args)
    check_form!(args, %i[train any])

    raise "The train #{args[0]} has no Route assigned!" unless @trains[args[0]].route

    case args[1]
    when 'forward' then @trains[args[0]].move_forward
    when 'back' then @trains[args[0]].move_backward
    else
      raise 'Wrong direction. Trains could move only back and forward.'
    end

    puts "Train #{args[0]} was successfully moved #{args[1]} "\
      "to the station #{@trains[args[0]].current_station.name}"
  end

  def occupy(args)
    check_form!(args, %i[wagon any])

    raise "Only CargoWagons could be 'occupied'" if @wagons[args[0]].type != :cargo

    @wagons[args[0]].occupy(args[1].to_i)
    puts "Wagon #{args[0]} is successfully filled with the stuff"
  end

  def take_seat(args)
    check_form!(args, [:wagon])

    raise 'Seats could be taken only in PassengerWagons' if @wagons[args[0]].type != :passenger

    @wagons[args[0]].take_seat
    puts "A seat in the PassengerWagon #{args[0]} has been taken"
  end
end
