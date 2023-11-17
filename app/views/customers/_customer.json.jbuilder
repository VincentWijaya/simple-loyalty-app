json.extract! customer, :id, :customerId, :customerName, :tierId, :created_at, :updated_at
json.url customer_url(customer, format: :json)
