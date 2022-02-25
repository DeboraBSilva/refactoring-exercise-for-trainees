require 'rails_helper'

RSpec.describe PurchaseManager::Stripe do

  describe '.call' do
    shared_examples 'using logged in user present into the cart' do
      context 'and there is a user present in cart' do
        let!(:user) { create(:user) }

        it 'does not create a guest user' do
          expect { PurchaseManager::Stripe.call(params) }.not_to change(User, :count)
        end
      end
    end

    shared_examples 'creating a new guest user' do
      context 'and there is no user present in cart, user params are valid' do
        let(:user) { nil }
        let(:params) do
          {
            gateway: gateway,
            cart_id: cart_id,
            user: {
              email: 'user@spec.io',
              first_name: 'John',
              last_name: 'Doe'
            }
          }
        end

        it 'creates new user' do
          expect { PurchaseManager::Stripe.call(params) }.to change(User, :count).by(1)
        end

        it 'created user should be guest' do
          PurchaseManager::Stripe.call(params)

          expect(User.last).to be_guest
        end
      end
    end

    shared_examples 'validating guest user info is valid' do
      context 'and there is no user present in cart, user params are not valid' do
        let(:user) { nil }
        let(:params) do
          {
            gateway: gateway,
            cart_id: cart_id,
            user: {}
          }
        end

        it 'does not create a guest user' do
          expect { PurchaseManager::Stripe.call(params) }.not_to change(User, :count)
        end

        it 'returns proper errors' do
          expect(PurchaseManager::Stripe.call(params)).to eq(
            { success: false, errors: [{message: "Email can't be blank"}, {message: "First name can't be blank"}, {message: "Last name can't be blank"}] }
          )
        end
      end
    end

    let(:gateway) { :stripe }
    let(:params) { { gateway: gateway, cart_id: cart_id } }

    context 'and cart does not exist' do
      let(:cart_id) { 1 }

      it 'returns proper errors' do
        expect(PurchaseManager::Stripe.call(params)).to eq(
          { success: false, errors: [{message: "Cart not found!"}] }
        )
      end
    end

    context 'and cart exists' do
      let!(:cart_id) { create(:cart, user: user).id }

      include_examples 'using logged in user present into the cart'

      include_examples 'creating a new guest user'

      include_examples 'validating guest user info is valid'
    end

    context 'and the purchase is successfull' do
      let!(:user) { create(:user) }
      let!(:cart) { create(:cart, user: user) }
      let!(:cart_id) { cart.id }

      let(:sale) { create(:sale, name: 'My Sale V', unit_price_cents: 1_900) }

      before do
        create(:cart_item, cart: cart, sale: sale, quantity: 3)
      end

      it 'creates order' do
        expect(PurchaseManager::Paypal.call(params)).to match(
          { success: true, order: {id: kind_of(Integer)}, errors: [] }
        )
      end
    end
  end
end
