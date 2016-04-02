json.array!(@customers) do |customer|
  json.extract! customer, :id, :custID, :interested, :bought
  json.url customer_url(customer, format: :json)
end
