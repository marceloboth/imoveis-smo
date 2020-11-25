class StrapassonScrapperService < ServicesBase
  URL = "http://imobiliariastrapasson.com.br/index/buscaavancada/finalidade/2/tipo/9/cidade/15/"
  QUERY = nil

  def call
    unparsed_page = Faraday.get(URL)
    parsed_page = Nokogiri::HTML(unparsed_page.body)

    houses_items = parsed_page.css('div.item-box')
    extracted_houses = houses_items.map do |house|
      {
        bathrooms: house.css('span.wc').text.strip,
        bedrooms: house.css('span.dorm').text.strip,
        price: house.css('h4 > span.pull-left').text.strip.delete("R$ ").delete(".").to_f,
        address: house.css('h1').text.strip,
        real_state: "Strapasson",
        origin_url: house.css('a').map {|a| a['href'] }.first,
        image: house.css('a > img').map {|img| img['src'] }.first
      }
    end

    House.where(real_state: "Strapasson").destroy_all
    House.create!(extracted_houses.uniq)
  end
end
