require 'sidekiq-scheduler'

class ScrapWebSitesWorker
  include Sidekiq::Worker

  def perform
    RealStateScrapperService.run
  end
end
