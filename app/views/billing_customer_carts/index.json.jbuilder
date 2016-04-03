json.array!(@billing_customer_carts) do |billing_customer_cart|
  json.extract! billing_customer_cart, :id, :cart
  json.url billing_customer_cart_url(billing_customer_cart, format: :json)
end
