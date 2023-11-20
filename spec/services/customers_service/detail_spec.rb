require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe CustomersService::Detail do
  let(:customer_id) { '123' }

  describe '#call' do
    subject { described_class.call(customer_id: customer_id) }

    context 'when the customer exists' do
      let!(:customer) { create(:customer, customerId: customer_id, tierId: 1) }
      let!(:tiers) { create_list(:tier, 3) }

      before do
        allow_any_instance_of(described_class).to receive(:calculate_customer_order).and_return(100)
        allow(Tier).to receive(:all).and_return(tiers)
      end

      it 'returns the customer details' do
        response = subject

        expect(response[:current_tier]).to eq(customer.tier.name)
        expect(response[:start_date]).to be_present
        expect(response[:total_spent]).to be_present
        expect(response[:downgraded_tier]).not_to be_present
        expect(response[:amount_needed_to_maintain_tier]).to be_present
        expect(response[:next_tier]).to be_present
      end
    end

    context 'when the customer does not exist' do
      it 'raises an error' do
        expect { subject }.to raise_error(CustomersService::Detail::Error, 'Invalid customer')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
