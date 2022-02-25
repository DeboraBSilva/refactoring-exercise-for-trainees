module PurchaseManager
  class Stripe < PurchaseGateway
    def initialize(purchase_params)
      @purchase_params = purchase_params
    end

    def save_order
      cart = CartManager::CartFinder.call(@purchase_params[:cart_id])

      user = UserManager::UserCreator.call(cart.user, @purchase_params[:user])

      if user.valid?
        order = OrderManager::OrderCreator.call(user, cart, @purchase_params[:address])

        if order.valid?
          return { success: true, order: { id: order.id }, errors: [] }
        else
          return { success: false, errors: order.errors.map(&:full_message).map { |message| { message: message } } }
        end
      else
        return { success: false, errors: user.errors.map(&:full_message).map { |message| { message: message } } }
      end
    rescue => exception
      return { success: false, errors: [{ message: exception.message }] }
    end
  end
end
