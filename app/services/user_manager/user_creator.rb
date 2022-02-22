module UserManager
  class UserCreator < ApplicationService
    def initialize(user_params)
      @user_params = user_params
    end

    def call
      create_user
    end

    private

    def create_user
      User.create(**@user_params.merge(guest: true))
    end
  end
end
