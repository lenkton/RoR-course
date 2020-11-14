# frozen_string_literal: true

require_relative 'text'
require './core/cargo_train'
require './core/passenger_train'
require './core/station'
require './core/route'
require_relative 'create'
require_relative 'form_checker'

class TextUI
  include Create
  include FormChecker

  def initialize
    @stations = {}
    @trains = {}
    @routes = {}
    @wagons = {}
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
    check_form!(args, [:train, :any, :any])

    if @wagons.include?(args[1])
      raise "A wagon with the name #{args[1]} already exist"
    end

    num = args[2].to_i

    case @trains[args[0]].class
    when :PassengerTrain
      wagon = PassengerWagon.new(num)
      @trains[args[0]].add_wagon(wagon)
    when :CargoTrain
      wagon = CargoWagon.new(num)
      @trains[args[0]].add_wagon(wagon)
    else
      raise TypeError, "Wrong class of train #{args[0]}"
    end

    @wagons[args[1]] << wagon

    puts "A #{wagon.class} was successfully added to the Train #{args[0]}"
  end

  def remove_wagon(args)
    check_form!(args, [:train])

    @trains[args[0]].remove_last_wagon
    puts "A wagon was successfully removed from the Train #{args[0]}"
  end

  def stations
    puts 'At the moment these stations were created:'
    @stations.each do |name, _st|
      _st.on_trains do |tr|
        puts tr.num, tr.type, wagon_list.size()
      end
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
    @stations[args[0]].trains.each do |tr|
      tr.on_wagons do |w|
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
    check_form!(args, [:train, :any])

    @trains[args[0]].occupy(args[1])
    pust "Wagon is successfully filled with the stuff"
  end

  def take_seat(args)
    check_form!(args, [:train, :any])

    @trains[args[0]].take_seat
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
    when 'require' then occupy(args)
    when 'take-seat' then take_seat(args)
    else
      raise "There is no command '#{command[0]}'"
    end
  end
end
