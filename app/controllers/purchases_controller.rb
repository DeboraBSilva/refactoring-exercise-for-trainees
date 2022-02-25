class PurchasesController < ApplicationController
  def create
    result = PurchaseManager::PurchaseCreator.call(purchase_params)
    if result[:success]
      render json: { success: true, order: result[:order] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.permit(
      :gateway,
      :cart_id,
      user: %i[email first_name last_name],
      address: %i[address_1 address_2 city state country zip]
    )
  end
end
