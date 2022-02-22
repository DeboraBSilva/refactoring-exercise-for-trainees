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
      cart_id = @purchase_params[:cart_id] 

      cart = Cart.find_by(id: cart_id)
  
      unless cart
        return {json: { errors: [{ message: 'Cart not found!' }] }, status: :unprocessable_entity}
      end
  
      user = if cart.user.nil?
               user_params = @purchase_params[:user] ? @purchase_params[:user] : {}
               User.create(**user_params.merge(guest: true))
             else
               cart.user
             end

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
          return {json: { status: :success, order: { id: order.id } }, status: :ok}
        else
          return {json: { errors: order.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity}
        end
      else
        return {json: { errors: user.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity}
      end
    elsif @purchase_params[:gateway] == 'stripe'
      cart_id = @purchase_params[:cart_id] 

      cart = Cart.find_by(id: cart_id)
  
      unless cart
        return {json: { errors: [{ message: 'Cart not found!' }] }, status: :unprocessable_entity}
      end
  
      user = if cart.user.nil?
               user_params = @purchase_params[:user] ? @purchase_params[:user] : {}
               User.create(**user_params.merge(guest: true))
             else
               cart.user
             end

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
          return {json: { status: :success, order: { id: order.id } }, status: :ok}
        else
          return {json: { errors: order.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity}
        end
      else
        return {json: { errors: user.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity}
      end
    else
      {json: { errors: [{ message: 'Gateway not supported!' }] }, status: :unprocessable_entity}
    end
  end

  def address_params
    @purchase_params[:address] || {}
  end

  def shipping_costs
    100
  end

end
