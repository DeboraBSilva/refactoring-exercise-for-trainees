require 'rails_helper'

RSpec.describe CartManager::CartFinder do
  describe '#call' do
    context 'when cart exists' do
      let!(:user) { create(:user) }
      let!(:cart) { create(:cart, user: user) }
      let!(:cart_id) { cart.id }
  
      it 'returns a cart' do
        cart_found = CartManager::CartFinder.call(cart_id)
        expect(cart_found.id).to eq(1)
      end
    end
   
    context 'when cart does not exists' do
      nonexistent_id = 1
      it 'returns nil' do
        cart_found = CartManager::CartFinder.call(nonexistent_id)
        expect(cart_found).to be_nil
      end
    end
  end
end
