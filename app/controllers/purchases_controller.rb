class PurchasesController < ApplicationController
  def create
    result = PurchaseManager::PurchaseCreator.call(purchase_params)
    if result.has_key?(:errors)
      render json: { errors: result[:errors] }, status: result[:status]
    else
      render json: { status: :success, order: result[:order] }, status: result[:status]
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
