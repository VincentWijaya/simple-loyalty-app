# spec/controllers/customers_controller_spec.rb

require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let(:customer) { create(:customer) }

  describe 'GET #show' do
    context 'when customer information is available' do
      before do
        allow(CustomersService::Detail).to receive(:call).and_return({ total_spent: 200, current_tier: 'Silver' })
        get :show, params: { id: customer.id }
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'renders the show template' do
        expect(response).to render_template('customer_info')
      end

      it 'assigns customer information' do
        expect(assigns(:progress_percentage)).to be_present
        expect(assigns(:progress_bar_color)).to be_present
        expect(assigns(:customer_id)).to eq(customer.id.to_s)
      end
    end
  end

  describe 'GET #order_history' do
    before do
      create_list(:order, 10, customerId: customer.id)
      get :order_history, params: { id: customer.id }
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'renders the order_history template' do
      expect(response).to render_template('order_history')
    end

    it 'assigns customer orders' do
      expect(assigns(:order_history)).to be_present
    end
  end
end
