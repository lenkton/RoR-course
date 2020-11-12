# frozen_string_literal: true

require_relative 'producer'

class Wagon
  include Producer

  def initialize
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
    raise 'Basic Wagon cannot be instantiated' if type.nil?
  end
end
