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
        Paypal.new(@purchase_params).save_order
      elsif @purchase_params[:gateway] == 'stripe'
        Stripe.new(@purchase_params).save_order
      else
        PurchaseGateway.new.save_order
      end
    end
  end
end
