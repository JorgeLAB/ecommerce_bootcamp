module Admin::V1
	class SystemRequirementsController < ApiController
		before_action :load_system_requirement, only: [:update, :destroy, :show]

		def index
  		@loading_service = Admin::ModelLoadingService.new(SystemRequirement.all, searchable_params)
  		@loading_service.call		
  	end

		def create
			@system_requirement = SystemRequirement.new
			save_system_requirement!
		end

		def show; end
		
		def update
			save_system_requirement!
		end

		def destroy
			@system_requirement.destroy!
		rescue
			render_error(fields: @system_requirement.errors.messages)
		end

		private 

		def system_requirement_params
			return {} unless params.has_key?(:system_requirement)
			params.require(:system_requirement).permit(:name, :memory, :storage, :operational_system, :video_board, :processor)
		end

		def load_system_requirement
			@system_requirement = SystemRequirement.find(params[:id])
		end

		def searchable_params
			params.permit( {seach: :name},{ order: {} }, :page, :length )
		end

		def save_system_requirement!
			@system_requirement.attributes = system_requirement_params			
			@system_requirement.save!

			render :show 
		rescue
			render_error(fields: @system_requirement.errors.messages)
		end
	end
end
