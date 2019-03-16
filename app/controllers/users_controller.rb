class UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: %i[create index]

    # GET /users/{username}
    def show
		render json: @user, status: :ok
    end

    # POST /users
    def create
		@user = User.new(user_params)
		begin
			@user.save!
			render json: true, status: :created
		rescue ActiveRecord::RecordNotUnique
			render json: ['user already exists'], status: 409
		end
    end

    # PUT /users/{username}
    def update
		unless @user.update(user_params)
			render json: { errors: @user.errors.full_messages },
			status: :unprocessable_entity
		end
    end

    private

    def find_user
		@user = User.find_by_email!(params[:_email])
		rescue ActiveRecord::RecordNotFound
			render json: { errors: 'User not found' }, status: :not_found
    end

    def user_params
		params.permit(
			:name, :email, :password
		)
    end
end