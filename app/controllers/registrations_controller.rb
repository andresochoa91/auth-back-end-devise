class RegistrationsController < Devise::RegistrationsController
    def create
        if !current_user
            @user = User.new(user_params)
            if @user.save        
                login_hash = User.handle_login(params[:email], params[:password])
                response.set_header('Authorization', login_hash[:token])
                render json: { message: "User created successfully" }, status: 201
            else
                render json: { error: @user.errors }, status: 409
            end
        else
            render json: { error: "User already logged" }, status: 409
        end
    end

    private

        def user_params
            params.permit(:email, :password, :password_confirmation)
        end
end