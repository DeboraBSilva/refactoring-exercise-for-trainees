module UserManager
  class UserCreator < ApplicationService
    def initialize(cart_user, user_params)
      @user_params = user_params
      @cart_user = cart_user
    end

    def call
      create_user
    end

    private

    def create_user
      if @cart_user.nil?
        params = @user_params? @user_params : {}
        User.create(**params.merge(guest: true))
      else
        @cart_user
      end
    end
  end
end
