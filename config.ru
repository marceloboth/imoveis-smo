# This file is used by Rack-based servers to start the application.

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

run Sidekiq::Web

require_relative 'config/environment'

run Rails.application

