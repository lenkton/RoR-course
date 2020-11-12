# frozen_string_literal: true

require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'text'
require_relative 'create.rb'

class TextUI
  include Create

  def initialize
    @stations = {}
    @trains = {}
    @routes = {}
  end

  def run
    @running = true
    puts GREETINGS
    puts HELP_REMINDER

    while @running
      print '>'
      command = gets.split
      begin
        run_command(command[0..-1]) unless command.empty?
      rescue RuntimeError => e
        puts e.message
      end
    end
  end

  protected

  # the following methods are actually useful for derived classes:
  # new commands could be added to the window procedure, and also
  # default messages (like 'create ...') could be rewritten
  def add_station(args)
    return unless correct_form?(args, %i[station route])

    @routes[args[1]].add_station(@stations[args[0]])
    puts "Station #{args[0]} was successfully added to the Route #{args[1]}"
  end

  def remove_station(args)
    return unless correct_form?(args, %i[station route])

    @routes[args[1]].remove_station(@stations[args[0]])
    puts "Station #{args[0]} was successfully removed from the Route #{args[1]}"
  end

  def add_wagon(args)
    return unless correct_form?(args, [:train])

    case @trains[args[0]].class
    when :PassengerTrain
      @trains[args[0]].add_wagon(PassengerWagon.new)
    when :CargoTrain
      @trains[args[0]].add_wagon(CargoWagon.new)
    end

    puts "A wagon was successfully added to the Train #{args[0]}"
  end

  def remove_wagon(args)
    return unless correct_form?(args, [:train])

    @trains[args[0]].remove_last_wagon
    puts "A wagon was successfully removed from the Train #{args[0]}"
  end

  def stations
    puts 'At the moment these stations were created:'
    @stations.each do |name, _st|
      puts name
    end
  end

  def assign(args)
    return unless correct_form?(args, %i[route train])

    @trains[args[1]].route = @routes[args[0]]
    puts "The Route #{args[0]} was successfully assigned to the Train #{args[1]}"
  end

  def trains(args)
    return unless correct_form?(args, [:station])

    puts "At the moment these Trains are at the Station #{args[0]}:"
    @stations[args[0]].trains.each do |tr|
      puts tr.num
    end
  end

  def move(args)
    return unless correct_form?(args, %i[train any])

    unless @trains[args[0]].route
      puts "The train #{args[0]} has no Route assigned!"
      return
    end

    case args[1]
    when 'forward' then @trains[args[0]].move_forward
    when 'back' then @trains[args[0]].move_backward
    else
      puts 'Error: wrong syntax. Trains could move only back and forward.'
      puts HELP_REMINDER
      return
    end

    puts "Train #{args[0]} was successfully moved #{args[1]} "\
      "to the station #{@trains[args[0]].current_station.name}"
  end

  def run_command(command)
    args = command [1..-1]
    case command[0]
    when 'q', 'quit' then @running = false
    when 'help', '?' then puts HELP
    when 'create' then create_object(args)
    when 'add-station' then add_station(args)
    when 'remove-station' then remove_station(args)
    when 'add-wagon' then add_wagon(args)
    when 'remove-wagon' then remove_wagon(args)
    when 'stations' then stations
    when 'assign' then assign(args)
    when 'trains' then trains(args)
    when 'move' then move(args)
    else
      puts "There is no command '#{command[0]}'"
      puts HELP_REMINDER
    end
  end

  private

  # following methods are not supposed to be called outside the class
  # and also are not quite suitable for reusage (however, maybe could
  # be useful)

  # checks, if a user command follows the convention
  def correct_form?(args, correct_args)
    if args.nil? || (args.size < correct_args.size)
      puts ARG_NUM_ERROR
      return
    end

    (0..(correct_args.size - 1)).each do |i|
      case correct_args[i]
      when :train
        unless @trains.include?(args[i])
          puts "Error! Train #{args[i]} does not exist!"
          puts HELP_REMINDER
          return
        end
      when :station
        unless @stations.include?(args[i])
          puts "Error! Station #{args[i]} does not exist!"
          puts HELP_REMINDER
          return
        end
      when :route
        unless @routes.include?(args[i])
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
end
