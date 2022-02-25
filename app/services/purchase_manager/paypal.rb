module PurchaseManager
  class Paypal < PurchaseGateway
    def initialize(purchase_params)
      @purchase_params = purchase_params
    end

    def save_order
      cart = CartManager::CartFinder.call(@purchase_params[:cart_id])

      user = UserManager::UserCreator.call(cart.user, @purchase_params[:user])

      if user.valid?
        order = Order.new(
          user: user,
          first_name: user.first_name,
          last_name: user.last_name,
          address_1: address_params[:address_1],
          address_2: address_params[:address_2],
          city: address_params[:city],
          state: address_params[:state],
          country: address_params[:country],
          zip: address_params[:zip],
        )

        cart.items.each do |item|
          item.quantity.times do
            order.items << OrderLineItem.new(
              order: order,
              sale: item.sale,
              unit_price_cents: item.sale.unit_price_cents,
              shipping_costs_cents: shipping_costs,
              paid_price_cents: item.sale.unit_price_cents + shipping_costs
            )
          end
        end

        order.save

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
    
    private

    def address_params
      @purchase_params[:address] || {}
    end

    def shipping_costs
      100
    end
  end
end
