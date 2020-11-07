require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'text'

class TextUI
  $istations = {}
  $trains = {}
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
        puts 'The Station already exists!'
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
        puts 'Cargo Train created successfully'
      when 'passenger', 'p'
        $trains[args[1]] = PassengerTrain.new(args[1])
        puts 'Passenger Train created successfully'
      else
        puts CREATE_FORMAT_ERROR
      end
    else
      puts CREATE_FORMAT_ERROR
    end
  end

  # checks, if a user command follows the convention
  def correct_form?(args, correct_args)
    if args.nil? || (args.size < correct_args.size)
      puts ARG_NUM_ERROR
      return
    end

    (0..(correct_args.size - 1)).each do |i|
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

      else
        puts 'DEBUG ALARM! WRONG correct_form?() usage!'
      end
    end

    true
  end

  def run
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
        create_object(command[1..-1])
      when 'add-station'
        next unless correct_form?(command[1..-1], %i[station route])

        $routes[command[2]].add_station($stations[command[1]])
        puts "Station #{command[1]} was successfully added to the Route #{command[2]}"
      when 'remove-station'
        next unless correct_form?(command[1..-1], %i[station route])

        $routes[command[2]].remove_station($stations[command[1]])
        puts "Station #{command[1]} was successfully removed from the Route #{command[2]}"
      when 'add-wagon'
        next unless correct_form?(command[1..-1], [:train])

        case $trains[command[1]].class
        when :PassengerTrain
          $trains[command[1]].add_wagon(PassengerWagon.new)
        when :CargoTrain
          $trains[command[1]].add_wagon(CargoWagon.new)
        end
        puts "A wagon was successfully added to the Train #{command[1]}"
      when 'remove-wagon'
        next unless correct_form?(command[1..-1], [:train])

        $trains[command[1]].remove_last_wagon
        puts "A wagon was successfully removed from the Train #{command[1]}"
      when 'stations'
        puts 'At the moment these stations were created:'
        $stations.each do |name, _st|
          puts name
        end
      when 'assign'
        next unless correct_form?(command[1..-1], %i[route train])

        $trains[command[2]].route = $routes[command[1]]
        puts "The Route #{command[1]} was successfully assigned to the Train #{command[2]}"
      when 'trains'
        next unless correct_form?(command[1..-1], [:station])

        puts "At the moment these Trains are at the Station #{command[1]}:"
        $stations[command[1]].trains.each do |tr|
          puts tr.num
        end
      when 'move'
        next unless correct_form?(command[1..-1], %i[train any])

        unless $trains[command[1]].route
          puts "The train #{command[1]} has no Route assigned!"
          next
        end

        case command[2]
        when 'forward'
          $trains[command[1]].move_forward
        when 'back'
          $trains[command[1]].move_backward
        else
          puts 'Error: wrong syntax. Trains could move only back and forward.'
          puts HELP_REMINDER
          next
        end

        puts "Train #{command[1]} was successfully moved #{command[2]} "\
          "to the station #{$trains[command[1]].current_station}"
      else
        puts "There is no command '#{command[0]}'"
        puts HELP_REMINDER
      end
    end
  end
end
