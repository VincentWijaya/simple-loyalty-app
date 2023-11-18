module CustomersService
  class Detail < ApplicationService
    Error = Class.new(StandardError)

    def initialize(customer_id:)
      @customer_id = customer_id
    end

    def call
      tiers = Tier.all.index_by(&:id)
      customer_tier = customer.find_tier_id(last_year_spent, tiers)

      build_response(tiers, customer_tier)
    rescue ActiveRecord::RecordNotFound
      raise Error, 'Invalid customer'
    end

    private

    def customer
      @customer ||= Customer.find_by!(customerId: @customer_id)
    end

    def last_year_spent
      @last_year_spent ||= calculate_customer_order(1.year.ago.beginning_of_year, Time.current.beginning_of_year)
    end

    def current_year_spent
      @current_year_spent ||= calculate_customer_order(Time.current.beginning_of_year, Time.current.end_of_year)
    end

    def calculate_customer_order(start_date, end_date)
      customer_orders = customer.order.where(date: start_date..end_date)
      customer.calculate_total_amount(customer_orders)
    end

    def amount_needed_to_maintain_tier(current_min_spent)
      amount_needed = current_min_spent - current_year_spent

      return 0 if amount_needed.negative?

      amount_needed
    end

    def amount_to_spent_for_next_tier(tiers, customer_tier)
      next_tier_min_spent = tiers.key?(customer_tier + 1) ? tiers[customer_tier + 1]['minSpent'] : tiers[tiers.length]['minSpent']
      next_tier_amount = next_tier_min_spent - last_year_spent
      next_tier_amount.negative? ? 0 : next_tier_amount
    end

    def determine_downgraded_tier(tiers, customer_tier)
      downgraded_tier_name = (customer_tier - 1).positive? ? tiers[customer_tier - 1]['name'] : tiers[1]['name']
      current_year_spent >= tiers[customer_tier]['minSpent'] ? nil : downgraded_tier_name
    end

    def build_response(tiers, customer_tier)
      {
        current_tier: customer.tier.name,
        start_date: 1.year.ago.beginning_of_year,
        total_spent: last_year_spent,
        amount_to_spent_for_next_tier: amount_to_spent_for_next_tier(tiers, customer_tier),
        downgraded_tier: determine_downgraded_tier(tiers, customer_tier),
        downgraded_date: Time.current.end_of_year,
        amount_needed_to_maintain_tier: amount_needed_to_maintain_tier(tiers[customer_tier]['minSpent'])
      }
    end
  end
end
