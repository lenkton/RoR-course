# frozen_string_literal: true

require './meta/accessors'

# module to hold a producer name
module Producer
  include Accessors

  attr_accessor_with_history :producer
end
