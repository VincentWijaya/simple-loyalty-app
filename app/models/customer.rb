class Customer < ApplicationRecord
  has_many :order, primary_key: 'customerId', foreign_key: 'customerId'

  def self.update_tier
    customers = Customer.includes(:order).all
    tiers = Tier.all.index_by(&:id)

    return unless customers.present?

    start_date = 1.year.ago.beginning_of_year
    end_date = Time.current.beginning_of_year

    customers.each do |customer|
      update_customer_tier(customer, start_date, end_date, tiers)
    end
  end

  def self.update_customer_tier(customer, start_date, end_date, tiers)
    customer_orders = customer.order.where(date: start_date..end_date)
    return unless customer_orders.present?

    total_amount = calculate_total_amount(customer_orders)
    tier_id = find_tier_id(total_amount, tiers)

    customer.update!(tierId: tier_id)
  end

  def self.calculate_total_amount(orders)
    orders.sum(&:totalInCents) / 100
  end

  def self.find_tier_id(total_amount, tiers)
    # tiers.each do |tier|
    #   return tier[0] if tier[1].minSpent >= total_amount
    # end

    matching_tier = tiers.find { |_, tier| tier.minSpent >= total_amount}
    matching_tier ? matching_tier.first : 1
  end
end
