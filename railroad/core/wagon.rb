# frozen_string_literal: true

require_relative 'producer'
require_relative 'railroad_exception'

# General Wagon class
class Wagon
  include Producer

  attr_reader :num

  def initialize(num)
    @num = num
    validate!
  end

  def type; end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private

  def validate!
    raise RailroadException, 'Basic Wagon cannot be instantiated' if type.nil?
  end
end
