class CustomersController < ApplicationController
  before_action :load_customer_info, only: [:show]

  MAX_TIER_SPENT = 500

  def show
    respond_to do |format|
      format.html do
        if @customer_info.present?
          prepare_customer_info_for_html
          render 'customer_info'
        else
          handle_customer_info_not_available
        end
      end

      format.json { render json: @customer_info }
    end
  rescue CustomersService::Detail::Error => e
    handle_error(e, 'Customer information not available.')
  end

  private

  def load_customer_info
    @customer_info = CustomersService::Detail.call(customer_id: params[:id])
  end

  def prepare_customer_info_for_html
    @progress_percentage = calculate_progress_percentage(@customer_info[:total_spent])
    @progress_bar_color = determine_progress_bar_color(@customer_info[:current_tier])
    @tier_milestones = calculate_tier_milestones
    @customer_id = params[:id]
  end

  def handle_customer_info_not_available
    flash.now[:error] = 'Customer information not available.'
    render 'customer_info'
  end

  def handle_error(exception, message)
    respond_to do |format|
      format.html do
        flash.now[:error] = message
        render 'customer_info'
      end
      format.json { render json: { error: exception.message }, status: :internal_server_error }
    end
  end

  def calculate_progress_percentage(total_spent)
    return 100 if total_spent >= MAX_TIER_SPENT

    total_spent.to_f / MAX_TIER_SPENT * 100
  end

  def determine_progress_bar_color(current_tier)
    case current_tier
    when 'Bronze'
      '#cd7f32'
    when 'Silver'
      '#c0c0c0'
    when 'Gold'
      '#ffd700'
    else
      '#000000'
    end
  end

  def calculate_tier_milestones
    tiers = Tier.all
    milestones = []

    tiers.each do |tier|
      milestone_percentage = (tier[:minSpent].to_f / 500 * 100).to_i
      milestones << { tier: tier.name, percentage: milestone_percentage }
    end

    milestones
  end
end
