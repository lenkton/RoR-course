module FormChecker

  private

  # following methods are not supposed to be called outside the class
  # and also are not quite suitable for reusage (however, maybe could
  # be useful)

  # checks, if a user command follows the convention
  def check_form!(args, correct_args)
    if args.nil? || (args.size < correct_args.size)
      raise ARG_NUM_ERROR
    end

    (0..(correct_args.size - 1)).each do |i|
      case correct_args[i]
      when :train
        unless @trains.include?(args[i])
          raise "Train #{args[i]} does not exist"
        end
      when :station
        unless @stations.include?(args[i])
          raise "Station #{args[i]} does not exist"
        end
      when :route
        unless @routes.include?(args[i])
          raise "Route #{args[i]} does not exist"
        end
      when :any

      else
        raise ArgumentError.new("Wrong correct_args in correct_form!()")
      end
    end
  end
end

