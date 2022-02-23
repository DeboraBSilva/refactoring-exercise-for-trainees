require 'rails_helper'

RSpec.describe PurchaseManager::PurchaseCreator, type: :request do
  include Requests

  describe '#call' do
    subject(:request!) { post '/purchases', params: params }

    context 'when gateway is valid' do
      let(:gateway) { :paypal }
      let(:params) { { gateway: gateway, cart_id: cart_id } }

      context 'and the purchase is successfull' do
        let!(:user) { create(:user) }
        let!(:cart) { create(:cart, user: user) }
        let!(:cart_id) { cart.id }

        before {request!}

        it 'returns status ok' do
          expect(response).to have_http_status(:ok)
        end       
      end
    end

    context 'when gateway is unknown' do
      let(:params) { { gateway: :unknown } }

      before { request! }

      it 'returns :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns proper errors' do
        expect(response_body_as_json).to eq(
          errors: [{ message: 'Gateway not supported!' }]
        )
      end
    end
  end
end
