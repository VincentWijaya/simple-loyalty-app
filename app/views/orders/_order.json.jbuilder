json.extract! order, :id, :customerId, :customerName, :orderId, :totalInCents, :date, :created_at, :updated_at
json.url order_url(order, format: :json)
