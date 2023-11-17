class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show ]

  def show
    customer_detail = CustomersService::Detail.call(customer_id: params[:id])
    render json: customer_detail
  rescue CustomersService::Detail::Error => e
    raise Errors::RequestParamsInvalid, e.message
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end
end
