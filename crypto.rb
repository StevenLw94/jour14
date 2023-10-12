require 'httparty'
require 'nokogiri'
require 'json'

def get_crypto_data
  url = 'https://coinmarketcap.com/all/views/all/'
  response = HTTParty.get(url)

  crypto_list = []

  if response.success?
    page = Nokogiri::HTML(response.body)
    page.css('table tbody tr').each do |row|
      cols = row.css('td')
      if cols[4]
        crypto = {
          name: cols[1].text.strip,
          price: cols[4].text.strip,
        }
        crypto_list << crypto
      end
    end
  end

  crypto_list
end

# Appel de la fonction et enregistrement des données dans un fichier JSON
crypto_data = get_crypto_data

File.open('crypto_data', 'w') do |file|
  file.puts JSON.pretty_generate(crypto_data)
end
