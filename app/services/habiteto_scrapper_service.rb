class HabitetoScrapperService < ServicesBase
  URL = "https://habiteto.com.br/index.php/imovel/buscar" 
  QUERY = 'tipo=locacao&categoria=19&bairro=&min_preco=0&max_preco=17500&search=1&busca_simples=1'

  def call
    unparsed_page = Faraday.post(URL, QUERY)
    parsed_page = Nokogiri::HTML(unparsed_page.body)

    houses_items = parsed_page.css('article')
    extracted_houses = houses_items.map do |house|
      {
        bathrooms: house.css('div.bathrooms').text.strip,
        bedrooms: house.css('div.bedrooms').text.strip,
        price: house.css('div.property-price').text.strip.delete("R$ ").delete(".").to_f,
        address: house.css('span.property-category').text.strip,
        real_state: "Habiteto",
        origin_url: house.css('div.property-action a').map { |link| link['href'] }.first,
        image: house.css('div.property-featured a > img').map { |img| img['src'] }.first
      }
    end

    House.where(real_state: "Habiteto").destroy_all
    House.create!(extracted_houses.uniq)
  end
end
