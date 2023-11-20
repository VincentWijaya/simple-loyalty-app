class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @customer_id = params[:customer_id]
    @page = params[:page].to_i || 1
    @per_page = params[:per_page].to_i || 5

    render json: orders(fetch_orders), status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: e.message }, status: :internal_server_error
  end

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        customer = Customer.find_by(customerId: order_params['customerId'])
        find_or_create_customer unless customer

        format.json { render json: @order, status: :created }
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
    customer.customerId = order_params['customerId']
    customer.customerName = order_params['customerName']
    customer.tierId = 1 # Set default tiers for new customer
    customer.save!
  end

  def fetch_orders
    Order.where(customerId: @customer_id)
         .paginate(page: @page, per_page: @per_page)
  end

  def orders(collection)
    {
      data: collection,
      total_pages: collection.total_pages,
      total_count: collection.total_entries,
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.previous_page,
      per_page: collection.per_page
    }
  end
end
