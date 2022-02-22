module CartManager
  class CartSelector < ApplicationService
    def initialize(cart_id)
      @cart_id = cart_id
    end

    def call
      find_cart
    end

    private

    def find_cart
      Cart.find_by(id: @cart_id)
    end
  end
end
