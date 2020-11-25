class SimobScrapperService
  include CallableService

  def call
    piovesan
    giusti
    imobiliaria_facil
    investir_empreendimentos
  end

  def piovesan
    url = "https://ipiovesan.simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas"
    conn = Faraday.new do |f|
      f.authorization :Bearer, "0e6ffdd8bca40773aa6abb5f795173af"
    end

    extract_from_simob(conn, url, real_state: "Piovesan", website: "http://piovesanimobiliaria.com.br/")
  end

  def giusti
    url = "https://simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas"
    conn = Faraday.new do |f|
      f.authorization :Bearer, "f8cf9171be43915263ed8b4b358608fa"
    end

    extract_from_simob(conn, url, real_state: "Guisti", website: "http://imobiliariagiusti.com.br/")
  end

  def imobiliaria_facil
    url = "https://simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas"
    conn = Faraday.new do |f|
      f.authorization :Bearer, "ade9126003d71320146a0700b1a62a31"
    end

    extract_from_simob(conn, url, real_state: "Imobiliária Fácil", website: "http://imobiliariafacilsmo.com.br/")
  end

  def investir_empreendimentos
    url = "https://simob.com.br/v2/integracaoApi/imovel/filtro/categoria/caracteristicas"
    conn = Faraday.new do |f|
      f.authorization :Bearer, "caba326ede3fc8ef2a0444316778cc83"
    end

    payload = '{"data":"{\"idsCategorias\":[4781],\"finalidade\":1,\"ceps\":[\"SÃO MIGUEL DO OESTE\"],\"idsBairros\":[],\"rangeValue\":{\"min\":0,\"max\":\"\"},\"caracteristicas\":[{\"id\":30603,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":false},{\"id\":30604,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":false},{\"id\":32515,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":false}],\"offset\":{\"maxResults\":12,\"firstResult\":0},\"acuracidade\":100,\"countResults\":false,\"considerarPrevisaoSaida\":0,\"calcularValorAbono\":false,\"orderBy\":[{\"sort\":\"valor\",\"descricao\":\"Valor\",\"order\":\"desc\",\"active\":false,\"type\":\"number\"}],\"trazerCaracteristicas\":3}"}'
    extract_from_simob(conn, url, payload: payload, real_state: "Investir Empreendimentos", website: "http://investirempreendimentos.com.br")
  end

  def extract_from_simob(conn, url, payload: nil, real_state:, website:)
    parsed_response = conn.post(
      url,
      payload || '{"data":"{\"idsCategorias\":[2875],\"finalidade\":1,\"ceps\":[\"SÃO MIGUEL DO OESTE\"],\"idsBairros\":[],\"rangeValue\":{\"min\":0,\"max\":\"\"},\"caracteristicas\":[{\"id\":7205,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":true},{\"id\":7162,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":true},{\"id\":7161,\"idTipoCaracteristica\":3,\"qtd\":0,\"considerarValorExato\":true}],\"offset\":{\"maxResults\":12,\"firstResult\":0},\"acuracidade\":100,\"countResults\":false,\"considerarPrevisaoSaida\":0,\"calcularValorAbono\":false,\"orderBy\":[{\"sort\":\"valor\",\"descricao\":\"Valor\",\"order\":\"asc\",\"active\":false,\"type\":\"number\"},{\"sort\":\"metrica\",\"order\":\"desc\"}],\"trazerCaracteristicas\":3}"}',
      "Content-Type" => "application/json"
    )

    return [] if parsed_response.status == 500
    houses_items = JSON.parse(parsed_response.body)["result"] || []
    extracted_houses = houses_items.map do |house|
      {
        bathrooms: house['caracteristicas'][1]['valor'],
        bedrooms: house['caracteristicas'][0]['valor'],
        price: house['valor'].to_f,
        address: "#{house['endereco']} #{house['bairro']}",
        real_state: real_state,
        origin_url: house_website_url(website, house),
        image: image_url(real_state, house)
      }
    end

    House.where(real_state: real_state).delete_all
    House.create!(extracted_houses)
  rescue
    Rails.logger.info ">>>> Connection problems with #{ real_state }"
  end

  private

  def house_website_url(website, house)
    "#{website}/imovel/exibir/locacao-casa-#{house['bairro']}-sao-miguel-do-oeste/#{house['codigo']}"
  end

  def image_url(real_state, house)
    if real_state == "Piovesan"
      "https://ipiovesan.simob.com.br/#{house['baseUrlImagem']}/#{house['imagem']}"
    else
      "https://simob.com.br/#{house['baseUrlImagem']}/#{house['imagem']}"
    end
  end
end
