module Admin::V1
	class UsersController < ApiController
		before_action :load_user, only: [:update, :destroy, :show]

		def index
  		@loading_service = Admin::ModelLoadingService.new(User.all, searchable_params)
  		@loading_service.call		
  	end

		def create
			@user = User.new
			save_user!
		end

		def show; end
		
		def update
			save_user!
		end

		def destroy
			@user.destroy!
		rescue
			render_error(fields: @user.errors.messages)
		end

		private 

		def user_params
			return {} unless params.has_key?(:user)
			params.require(:user).permit( :name, :email, :password, :password_confirmation, :profile )
		end

		def load_user
			@user = User.find( params[:id] )
		end

		def searchable_params
			params.permit({search: :name }, { order: {} }, :page, :length)
		end

		def save_user!
			@user.attributes = user_params
			@user.save!

			render :show 
		rescue
			render_error(fields: @user.errors.messages)
		end
	end
end 