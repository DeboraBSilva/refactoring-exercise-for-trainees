module PurchaseManager
  class PurchaseGateway < ApplicationService
    def call
      save_order
    end

    private

    def save_order
      { success: false, errors: [{ message: 'Gateway not supported!' }] }
    end
  end
end
