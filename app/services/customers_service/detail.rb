module CustomersService
  class Detail < ApplicationService
    Error = Class.new(StandardError)

    def initialize(customer_id:)
      @customer_id = customer_id
    end

    def call
      customer
    rescue ActiveRecord::RecordNotFound
      raise Error, 'Invalid customer'
    end

    private

    def customer
      @customer ||= Customer.find(@customer_id)
    end
  end
end
