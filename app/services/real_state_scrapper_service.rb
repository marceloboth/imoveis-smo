require 'faraday'
require 'nokogiri'

class RealStateScrapperService
  def self.run
    HabitetoScrapperService.call
    StrapassonScrapperService.call
    SimobScrapperService.call
  end 
end
