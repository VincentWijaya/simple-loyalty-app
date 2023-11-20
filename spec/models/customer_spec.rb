require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '#update_tier' do
    let(:customer) { create(:customer, tierId: 1, customerId: '123') }
    let!(:tiers) do
      [
        { id: 1, name: 'Bronze', minSpent: 0 },
        { id: 2, name: 'Silver', minSpent: 100 },
        { id: 3, name: 'Gold', minSpent: 500 }
      ].each { |tier| create(:tier, tier) }
    end

    before do
      create_list(:order, 3, customerName: 'John', customerId: customer.customerId, totalInCents: 5_000, date: 1.year.ago)
    end

    it 'updates the tier correctly' do
      tiers_data = Tier.all.index_by(&:id)
      start_date = 1.year.ago.beginning_of_year
      end_date = Time.current.beginning_of_year

      customer.update_tier(start_date, end_date, tiers_data)

      customer.reload

      expect(customer.tierId).to eq(2)
    end
  end
end
