require 'rails_helper'

RSpec.describe UserManager::UserCreator do
  describe '#call' do
    context 'when user have params' do
      let(:user) do 
        { 
          email: 'user@spec.io',
          first_name: 'John',
          last_name: 'Doe' 
        }
      end

      it 'creates a user' do
        UserManager::UserCreator.call(user)

        user_created = User.find_by(first_name: 'John')
        expect(user_created.email).to eq('user@spec.io')
        expect(user_created.first_name).to eq('John')
        expect(user_created.last_name).to eq('Doe')
      end
    end
  end
end
