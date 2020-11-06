require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'text'

$stations = {}
$trains = {}
# wagons = {}
$routes = {}

def create_object(args)
  if args[0] == '--help'
    puts CREATE_HELP
    return
  end

  if args.size < 2
    puts CREATE_FORMAT_ERROR
    return
  end
  
  case args[0]
  # station creation
  when 'station'
    if $stations.include?(args[1])
      puts "The Station already exists!"
      return
    end

    $stations[args[1]] = Station.new(args[1])
    puts "Station #{args[1]} created successfully"

  # route creation
  when 'route'
    if $routes.include?(args[1])
      puts "The Route #{args[1]} already exists!"
      return
    end

    if args.size < 4
      puts CREATE_FORMAT_ERROR
      return
    end

    unless $stations.include?(args[2])
      puts "Error! Station #{args[2]} does not exist!"
      return
    end

    unless $stations.include?(args[3])
      puts "Error! Station #{args[3]} does not exist!"
      return
    end

    $routes[args[1]] = Route.new(
      $stations[args[2]], $stations[args[3]], args[1]
    )
    puts "The Route #{args[1]} from #{args[2]} "\
      "to #{args[3]} created successfully"

  # train creation
  when 'train'
    if $trains.include?(args[1])
      puts "The Train #{args[1]} already exists!"
      return
    end
    
    if args.size < 3
      puts CREATE_FORMAT_ERROR
      return
    end

    case args[2]
    when 'cargo', 'car'
      $trains[args[1]] = CargoTrain.new(args[1])
      puts "Cargo Train created successfully"
    when 'passenger', 'p'
      $trains[args[1]] = PassengerTrain.new(args[1])
      puts "Passenger Train created successfully"
    else
      puts CREATE_FORMAT_ERROR
    end
  
  # wagon creation
  when 'wagon'
    # todo
  else
    puts CREATE_FORMAT_ERROR
  end
end

running = true
puts GREETINGS
puts HELP_REMINDER

while running
  print '>'
  command = gets.split
  case command[0]
  when 'q'
    running = false
  when 'quit'
    running = false
  when 'help', '?'
    puts HELP
  when 'create'
    create_object(command[1 .. -1])
  else
    puts HELP_REMINDER
  end
end

