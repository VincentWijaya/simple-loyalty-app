class CustomersController < ApplicationController
  before_action :load_customer_info, only: [:show]
  before_action :load_order_history, only: [:order_history]
  MAX_TIER_SPENT = 500

  def show
    respond_to do |format|
      format.html { handle_html_response }
      format.json { render json: @customer_info }
    end
  rescue CustomersService::Detail::Error => e
    handle_error(e, 'Customer information not available.')
  end

  def order_history
    respond_to do |format|
      format.html { @order_history }
      format.json { render json: orders(@order_history) }
    end
  end

  private

  def load_customer_info
    @customer_info = CustomersService::Detail.call(customer_id: params[:id])
  end

  def handle_html_response
    @customer_info.present? ? render_html : handle_customer_info_not_available
  end

  def render_html
    prepare_customer_info_for_html
    render 'customer_info'
  end

  def handle_customer_info_not_available
    flash.now[:error] = 'Customer information not available.'
    render 'customer_info'
  end

  def prepare_customer_info_for_html
    @progress_percentage = calculate_progress_percentage(@customer_info[:total_spent])
    @progress_bar_color = determine_progress_bar_color(@customer_info[:current_tier])
    @customer_id = params[:id]
  end

  def calculate_progress_percentage(total_spent)
    total_spent >= MAX_TIER_SPENT ? 100 : total_spent.to_f / MAX_TIER_SPENT * 100
  end

  def determine_progress_bar_color(current_tier)
    case current_tier
    when 'Bronze' then '#cd7f32'
    when 'Silver' then '#c0c0c0'
    when 'Gold' then '#ffd700'
    else '#000000'
    end
  end

  def handle_error(exception, message)
    respond_to do |format|
      format.html { render_error_html(message) }
      format.json { render json: { error: exception.message }, status: :internal_server_error }
    end
  end

  def render_error_html(message)
    flash.now[:error] = message
    render 'customer_info'
  end

  def load_order_history
    per_page = params[:per_page].to_i | 5
    @order_history = Order.where(customerId: params[:id])
                          .paginate(page: params[:page], per_page: per_page)
  end

  def orders(collection)
    @order_data = {
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
