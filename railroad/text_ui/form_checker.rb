# frozen_string_literal: true

require_relative 'text'

# checks the form of a query
module FormChecker
  private

  # following methods are not supposed to be called outside the class
  # and also are not quite suitable for reusage (however, maybe could
  # be useful)

  def array_of(type)
    arrays = {
      train: @trains,
      station: @stations,
      route: @routes,
      wagon: @wagons
    }

    arrays[type]
  end

  def class_name_of(type)
    names = {
      train: 'Train',
      station: 'Station',
      route: 'Route',
      wagon: 'Wagon'
    }

    names[type]
  end

  def check_arg(arg, correct_arg)
    return if correct_arg == :any

    raise ArgumentError, 'Wrong correct_args in correct_form!()' if class_name_of(correct_arg).nil?

    raise "#{class_name_of(correct_arg)} #{arg} does not exist" unless array_of(correct_arg).include?(arg)
  end

  # checks, if a user command follows the convention
  def check_form!(args, correct_args)
    raise ARG_NUM_ERROR if args.nil? || (args.size < correct_args.size)

    (0..(correct_args.size - 1)).each do |i|
      check_arg(args[i], correct_args[i])
    end
  end
end
