require 'rails_helper'

RSpec.describe PurchaseManager::PurchaseCreator do

  describe '.call' do
    context 'when gateway is valid' do
      let(:gateway) { 'paypal' }
      let(:params) { { gateway: gateway, cart_id: cart_id } }

      context 'and the purchase is successfull' do
        let!(:user) { create(:user) }
        let!(:cart) { create(:cart, user: user) }
        let!(:cart_id) { cart.id }

        it 'returns status ok' do
          expect(PurchaseManager::PurchaseCreator.call(params)).to include(status: :ok)
        end       
      end
    end

    context 'when gateway is unknown' do
      let(:params) { { gateway: :unknown } }

      it 'returns proper errors' do
        expect(PurchaseManager::PurchaseCreator.call(params)).to eq(
          {errors: [{message: "Gateway not supported!"}], status: :unprocessable_entity}
        )
      end
    end
  end
end
