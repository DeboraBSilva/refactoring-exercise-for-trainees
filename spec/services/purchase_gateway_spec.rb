require 'rails_helper'

RSpec.describe PurchaseManager::PurchaseGateway do
  describe '.call' do
    response = PurchaseManager::PurchaseGateway.call

    it 'returns proper error' do
      expect(response).to eq(
        {json: {errors: [{message: "Gateway not supported!"}]}, status: :unprocessable_entity}
      )
    end
  end
end
