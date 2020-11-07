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

# checks, if a user command follows the convention
def correct_form?(args, correct_args)
  if args == nil or args.size < correct_args.size
    puts ARG_NUM_ERROR
    return
  end

  for i in 0 .. correct_args.size
    case correct_args[i]
    when :train
      unless $trains.include?(args[i])
        puts "Error! Train #{args[i]} does not exist!"
        puts HELP_REMINDER
        return
      end
    when :station
      unless $stations.include?(args[i])
        puts "Error! Station #{args[i]} does not exist!"
        puts HELP_REMINDER
        return
      end
    when :route
      unless $routes.include?(args[i])
        puts "Error! Route #{args[i]} does not exist!"
        puts HELP_REMINDER
        return
      end
    when :any
      ;
    else
      puts "DEBUG ALARM! WRONG correct_form?() usage!"
    end
  end

  true
end

def main
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
    when 'add-station'
      return unless correct_form?(command[1 .. -1], [:station, :route])

      $routes[command[2]].add_station($stations[command[1]])
    when 'remove-station'
      return unless correct_form?(command[1..-1], [:station, :route])
      $routes[command[2]].remove_station($stations[command[1]])
    when 'add-wagon'
      return unless correct_form?(command[1..-1], [:train])
      
      case $trains[command[1]].type
      when :passenger
        $trains[command[1]].add_wagon(PassengerWagon.new())
      when :cargo
        $trains[command[1]].add_wagon(CargoWagon.new())
      end
    when 'remove-wagon'
      return unless correct_form?(command[1..-1], [:train])
      $trains[command[1]].remove_last_wagon
    when 'stations'
      for st in $stations
        puts st.name
      end
    when 'assign'
      return unless correct_form?(command[1..-1], [:route, :train])
      $trains[command[2]].route = $routes[command[1]]
    when 'trains'
      return unless correct_form?(command[1..-1], [:station])
      
      for tr in $stations[command[1]]
        puts tr.name
      end
    when 'move'
      return unless correct_form?(command[1..-1], [:train, :any])

      case command[2]
      when 'forward'
        $trains[command[1]].move_forward
      when 'back'
        $trains[command[1]].move_backward
      else
        puts "Error: wrong syntax. Trains could move only back and forward."
        puts HELP_REMINDER
      end
    else
      puts HELP_REMINDER
    end
  end
end

