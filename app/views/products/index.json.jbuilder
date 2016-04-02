json.array!(@products) do |product|
  json.extract! product, :id, :name, :count, :row, :col
  json.url product_url(product, format: :json)
end
