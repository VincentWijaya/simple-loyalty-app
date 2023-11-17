class Order < ApplicationRecord
  belongs_to :Customer, primary_key: 'customerId'
end
