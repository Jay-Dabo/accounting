json.array!(@funds) do |fund|
  json.extract! fund, :id
  json.url fund_url(fund, format: :json)
end
