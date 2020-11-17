# frozen_string_literal: true

require_relative 'producer'
require_relative 'railroad_exception'

# General Wagon class
class Wagon
  include Producer

  attr_reader :num

  validate :type, :presence
  validate :num, :presence

  def initialize(num)
    @num = num
    @type = type
    validate!
  end

  def type; end
end
