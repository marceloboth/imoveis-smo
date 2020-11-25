require 'faraday'
require 'nokogiri'

class ServicesBase
  URL = ""
  QUERY = ""

  include CallableService

  # attr_accessor :unparsed_page, :parsed_page
  #
  # def initialize
  #   connect
  #   parse_page
  # end
  #
  # def connect
  #   @unparsed_page = Faraday.post(URL, QUERY)
  # end
  #
  # def parse_page
  #   @parsed_page = Nokogiri::HTML(@unparsed_page.body)
  # end
end
