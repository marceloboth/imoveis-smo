class SearchController < ApplicationController
  def index
    @houses = House.all.order(:price)
  end
end
