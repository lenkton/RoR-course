require_relative 'text'

module FormChecker
  private

  # following methods are not supposed to be called outside the class
  # and also are not quite suitable for reusage (however, maybe could
  # be useful)

  # checks, if a user command follows the convention
  def check_form!(args, correct_args)
    raise ARG_NUM_ERROR if args.nil? || (args.size < correct_args.size)

    (0..(correct_args.size - 1)).each do |i|
      case correct_args[i]
      when :train
        raise "Train #{args[i]} does not exist" unless @trains.include?(args[i])
      when :station
        raise "Station #{args[i]} does not exist" unless @stations.include?(args[i])
      when :route
        raise "Route #{args[i]} does not exist" unless @routes.include?(args[i])
      when :any

      else
        raise ArgumentError, 'Wrong correct_args in correct_form!()'
      end
    end
  end
end
