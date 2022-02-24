module CartManager
  class CartFinder < ApplicationService
    def initialize(cart_id)
      @cart_id = cart_id
    end

    def call
      find_cart
    end

    private

    def find_cart
      cart = Cart.find_by(id: @cart_id)
      raise 'Cart not found!' unless cart
      return cart
    end
  end
end
