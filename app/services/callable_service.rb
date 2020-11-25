# frozen_string_literal: true

# This module should be included into all services, to enable a
# shorthand for creating and then calling the service. So, instead
# of...
#   MyService.new(param1, param2).call
# ...we can instead...
#   MyService.call(param1, param2)
module CallableService
  extend ActiveSupport::Concern

  class_methods do
    def call(*args, &block)
      new(*args, &block).call
    end
  end
end