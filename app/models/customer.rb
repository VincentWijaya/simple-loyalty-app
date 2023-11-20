class Customer < ApplicationRecord
  has_many :order, primary_key: 'customerId', foreign_key: 'customerId'
  has_one :tier, primary_key: 'tierId', foreign_key: 'id'

  def self.update_tier
    customers = Customer.includes(:order).all
    tiers = Tier.all.index_by(&:id)

    return unless customers.present?

    start_date = 1.year.ago.beginning_of_year
    end_date = Time.current.beginning_of_year

    customers.each do |customer|
      customer.update_tier(start_date, end_date, tiers)
    end
  end

  def update_tier(start_date, end_date, tiers)
    customer_orders = self.order.where(date: start_date..end_date)

    total_amount = calculate_total_amount(customer_orders)
    tier_id = find_tier_id(total_amount, tiers)

    update!(tierId: tier_id)
  end

  def calculate_total_amount(orders)
    return 0 unless orders.present?

    orders.sum(&:totalInCents) / 100
  end

  def find_tier_id(total_amount, tiers)
    positive_tiers = tiers.select { |_, tier| total_amount - tier.minSpent >= 0 }
    matching_tier = positive_tiers.min_by { |_, tier| total_amount - tier.minSpent }

    if matching_tier
      matching_tier.first
    else
      1
    end
  end
end
