class CustomersController < ApplicationController
  def show
    customer_detail = CustomersService::Detail.call(customer_id: params[:id])
    render json: customer_detail
  rescue CustomersService::Detail::Error => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
