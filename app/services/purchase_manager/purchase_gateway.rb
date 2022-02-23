module PurchaseManager
  class PurchaseGateway < ApplicationService
    def call
      save_order
    end

    private

    def save_order
      {json: { errors: [{ message: 'Gateway not supported!' }] }, status: :unprocessable_entity}
    end
  end
end
