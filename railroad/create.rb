module Create
  # made protected to allow overriding
  protected

  def create_object(command)
    raise "Missing arguments for 'create'" if command.empty?

    args = command[1..-1]

    case command[0]
    when '--help' then puts CREATE_HELP
    when 'station' then create_station(args)
    when 'route' then create_route(args)
    when 'train' then create_train(args)
    else
      raise "Wrong arguments for 'create'"
    end
  end
  
  def create_station(args)
    return puts CREATE_FORMAT_ERROR if args.empty?

    name = args[0]

    return puts "Station #{name} already exists!" if @stations.include?(name)

    @stations[name] = Station.new(name)
    puts "Station #{name} created successfully"
  end

  def create_route(args)
    return unless correct_form?(args, %i[any station station])

    name, first, last = args

    if @routes.include?(name)
      puts "The Route #{name} already exists!"
      return
    end

    @routes[name] = Route.new(@stations[first], @stations[last], name)
    puts "The Route #{name} from #{first} to #{last} created successfully"
  end

  def create_train(args)
    # TODO: create catch statement in the body of the text ui
    raise "Wrong number of arguments to 'create'" if args.size != 2

    name, type = args

    raise "The Train #{name} already exists!" if @trains.include?(name)

    case type
    when 'cargo', 'car'
      @trains[name] = CargoTrain.new(name)
      puts "Cargo Train #{name} created successfully"
    when 'passenger', 'p'
      @trains[name] = PassengerTrain.new(name)
      puts "Passenger Train #{name} created successfully"
    else
      raise 'Wrong type of a train'
    end
  end
end
