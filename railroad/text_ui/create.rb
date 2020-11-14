# frozen_string_literal: true

require_relative 'form_checker'
require './core/cargo_train'
require './core/passenger_train'
require './core/station'
require './core/route'

# handles 'create' command
module Create
  include FormChecker

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
    raise "Missing arguments for 'create station'" if args.empty?

    name = args[0]

    raise "Station #{name} already exists!" if @stations.include?(name)

    @stations[name] = Station.new(name)
    puts "Station #{name} created successfully"
  end

  def create_route(args)
    check_form!(args, %i[any station station])
    name, first, last = args

    raise "The Route #{name} already exists!" if @routes.include?(name)

    @routes[name] = Route.new(@stations[first], @stations[last], name)
    puts "The Route #{name} from #{first} to #{last} created successfully"
  end

  def create_train(args)
    check_form!(args, %i[any any])
    raise "The Train #{args[0]} already exists!" if @trains.include?(args[0])

    name, type = args
    case type
    when 'cargo', 'car' then @trains[name] = CargoTrain.new(name)
    when 'passenger', 'p' then @trains[name] = PassengerTrain.new(name)
    else raise 'Wrong type of a train'
    end
    puts "#{@trains[name].class} #{name} created successfully"
  end
end
