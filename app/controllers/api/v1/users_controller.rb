module API
  module V1
    class UsersController < ApiController
      before_action :authenticate_with_token!, only: [:update, :destroy]
      before_action :set_user, only: [:show, :update, :destroy]

      respond_to :json

      def show
        respond_with(@user)
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: user, status: :created, location: [:api, user]
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      def update
        if current_user.update(user_params)
          render json: current_user, status: :ok, location: [:api, current_user]
        else
          render json: { errors: current_user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        current_user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find params[:id]
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end
  end
end
