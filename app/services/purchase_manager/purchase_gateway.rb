module PurchaseManager
  class PurchaseGateway
    def save_order
      {json: { errors: [{ message: 'Gateway not supported!' }] }, status: :unprocessable_entity}
    end
  end
end
