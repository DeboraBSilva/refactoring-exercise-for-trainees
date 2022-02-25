module PurchaseManager
  class PurchaseCreator < ApplicationService
    def initialize(purchase_params)
      @purchase_params = purchase_params
    end

    def call
      create_purchase
    end

    private
    
    def create_purchase
      if @purchase_params[:gateway] == 'paypal'
        Paypal.call(@purchase_params)
      elsif @purchase_params[:gateway] == 'stripe'
        Stripe.call(@purchase_params)
      else
        PurchaseGateway.call
      end
    end
  end
end
