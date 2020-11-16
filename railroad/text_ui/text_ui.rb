# frozen_string_literal: true

require_relative 'text'
require './core/cargo_train'
require './core/passenger_train'
require './core/station'
require './core/route'
require_relative 'create'
require_relative 'form_checker'
require_relative 'commands'
require_relative 'tui_exception'

# the main class
class TextUI
  include Create
  include FormChecker
  include Commands

  def initialize
    @stations = {}
    @trains = {}
    @routes = {}
    @wagons = {}
  end

  def run
    @running = true
    puts GREETINGS, HELP_REMINDER

    while @running
      print '>'
      command = gets.split
      begin
        run_command(command[0..-1]) unless command.empty?
      rescue RailroadException => e
        puts e.message
      end
    end
  end

  protected

  # the following methods are actually useful for derived classes:
  # new commands could be added to the window procedure, and also
  # default messages (like 'create ...') could be rewritten

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
    when 'wagons' then wagons(args)
    else
      raise TUIException, "There is no command '#{command[0]}'"
    end
  end
end
