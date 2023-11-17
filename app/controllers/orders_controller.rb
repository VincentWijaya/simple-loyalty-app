class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        customer = Customer.find_by(customerId: order_params['customerId'])
        find_or_create_customer unless customer

        format.json { render :show, status: :created, location: @order }
      else
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:customerId, :customerName, :orderId, :totalInCents, :date)
  end

  def find_or_create_customer
    customer = Customer.new
    puts customer.to_json
    customer.customerId = order_params['customerId']
    customer.customerName = order_params['customerName']
    customer.tierId = 1 # Set default tiers for new customer
    customer.save!
  end
end
