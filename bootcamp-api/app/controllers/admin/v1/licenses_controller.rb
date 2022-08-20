module Admin::V1
  class LicensesController < ApiController
    before_action :load_license, only: [:show, :update]

    def index
      @loading_service = Admin::ModelLoadingService.new(License.all, searchable_params)
      @loading_service.call
    end

    def create
      license_user = User.find(params[:license][:user_id])

      @license = License.new
      @license.attributes = { user_id: license_user.id, key: SecureRandom.hex(16) }

      @license.save!

      render :show
    rescue => e
      render_error(fields: e)
    end

    def show; end

    def update
      @license.attributes = { key: params[:license][:key] }
      @license.save!
      render :show

    rescue => e
      render_error(fields: e)
    end

    private

    def load_license
      @license = License.find(params[:id])
    end

    def searchable_params
      params.permit( { search: :name }, { order: {} }, :page, :length )
    end
  end
end
