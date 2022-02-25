require 'rails_helper'

RSpec.describe UserManager::UserCreator do
  describe '.call' do
    context 'using logged in user present into the cart' do
      context 'and there is a user present in cart' do
        let(:user) do 
          { 
            email: 'user@spec.io',
            first_name: 'John',
            last_name: 'Doe' 
          }
        end
        let!(:cart) { create(:user) }

        it 'does not create a guest user' do
          expect { UserManager::UserCreator.call(cart, user) }.not_to change(User, :count)
        end
      end
    end

    context 'creating a new guest user' do
      context 'and there is no user present in cart, user params are valid' do
        let(:user) do
          {
            email: 'user@spec.io',
            first_name: 'John',
            last_name: 'Doe'
          }
        end

        it 'creates new user' do
          expect { UserManager::UserCreator.call(nil, user) }.to change(User, :count).by(1)
        end

        it 'created user should be guest' do
          UserManager::UserCreator.call(nil, user)

          expect(User.last).to be_guest
        end
      end
    end

    context 'validating guest user info is valid' do
      context 'and there is no user present in cart, user params are not valid' do
        let(:user) { }

        it 'does not create a guest user' do
          expect { UserManager::UserCreator.call(nil, user) }.not_to change(User, :count)
        end
      end
    end
  end
end
