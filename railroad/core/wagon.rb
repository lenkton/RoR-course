# frozen_string_literal: true

require_relative 'producer'
require_relative 'railroad_exception'
require './meta/validation'

# General Wagon class
class Wagon
  include Producer
  include Validation

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
