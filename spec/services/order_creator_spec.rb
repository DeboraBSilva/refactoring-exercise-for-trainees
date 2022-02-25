require 'rails_helper'

RSpec.describe OrderManager::OrderCreator do
  describe '.call' do
    context 'purchase is successfull' do
      let!(:user) { create(:user) }
      let!(:cart) { create(:cart, user: user) }
      let!(:cart_id) { cart.id }

      let(:sale) { create(:sale, name: 'My Sale V', unit_price_cents: 1_900) }

      before do
        create(:cart_item, cart: cart, sale: sale, quantity: 3)
      end

      it 'creates order' do
        expect { OrderManager::OrderCreator.call(user, cart, nil) }.to change(Order, :count).by(1)
      end

      it 'creates order line items' do
        expect { OrderManager::OrderCreator.call(user, cart, nil) }.to change(OrderLineItem, :count).by(3)
      end

      it 'create order line items with proper attributes' do
        OrderManager::OrderCreator.call(user, cart, nil)

        expect(
          OrderLineItem.pluck(:unit_price_cents, :shipping_costs_cents, :taxes_cents, :paid_price_cents)
        ).to eq([[1_900, 100, 0, 2_000], [1_900, 100, 0, 2_000], [1_900, 100, 0, 2_000]])
      end

      it "calculates order's subtotal_cents properly" do
        OrderManager::OrderCreator.call(user, cart, nil)

        expect(Order.last.subtotal_cents).to eq 5_700
      end

      it "calculates order's total properly" do
        OrderManager::OrderCreator.call(user, cart, nil)

        expect(Order.last.total_cents).to eq 6_000
      end
    end
  end
end
