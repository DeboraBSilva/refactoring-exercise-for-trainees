require 'rails_helper'

RSpec.describe PurchaseManager::PurchaseGateway do
  describe '.call' do
    response = PurchaseManager::PurchaseGateway.call

    it 'returns proper error' do
      expect(response).to eq(
        { success: false, errors: [{message: "Gateway not supported!"}] }
      )
    end
  end
end
