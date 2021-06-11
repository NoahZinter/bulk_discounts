class NagerService
  def self.holidays(country)
    response = Faraday.get "https://date.nager.at/api/v3/publicholidays/#{Date.today.year}/#{country}"
    body = response.body
    JSON.parse(body)
  end
end