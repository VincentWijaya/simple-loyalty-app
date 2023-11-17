module CustomersService
  class Detail < ApplicationService
    Error = Class.new(StandardError)

    def initialize(customer_id:)
      @customer_id = customer_id
    end

    def call
      tiers = Tier.all.index_by(&:id)
      customer_tier = customer.find_tier_id(last_year_spent, tiers)

      next_tier_min_spent = tiers.key?(customer_tier + 1) ? tiers[customer_tier + 1]['minSpent'] : 0
      downgraded_tier = (customer_tier - 1).positive? ? tiers[customer_tier - 1]['name'] : tiers[1]['name']

      {
        current_tier: customer.tier.name,
        start_date: 1.year.ago.beginning_of_year,
        total_spent: last_year_spent,
        amount_to_spent_for_next_tier: next_tier_min_spent,
        downgraded_tier: downgraded_tier,
        downgraded_date: Time.current.end_of_year,
        amount_needed_to_maintain_tier: amount_needed_to_maintain_tier(tiers)
      }
    rescue ActiveRecord::RecordNotFound
      raise Error, 'Invalid customer'
    end

    private

    def customer
      @customer ||= Customer.find(@customer_id)
    end

    def last_year_spent
      @last_year_spent ||= calculate_customer_order(1.year.ago.beginning_of_year, Time.current.beginning_of_year)
    end

    def current_year_spent
      start_date = Time.current.beginning_of_year
      end_date = Time.current.end_of_year

      calculate_customer_order(start_date, end_date)
    end

    def calculate_customer_order(start_date, end_date)
      customer_orders = customer.order.where(date: start_date..end_date)
      customer.calculate_total_amount(customer_orders)
    end

    def amount_needed_to_maintain_tier(tiers)
      next_tier_id = customer.find_tier_id(last_year_spent, tiers) + 1

      return 0 unless tiers.key?(next_tier_id.to_s)

      next_tier_min_spent = tiers[next_tier_id.to_s]['minSpent']
      difference = next_tier_min_spent - current_year_spent

      difference.positive? ? difference : 0
    end
  end
end
