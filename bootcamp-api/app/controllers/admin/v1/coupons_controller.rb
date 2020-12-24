module Admin::V1
	class CouponsController < ApiController
		before_action :load_coupon, only: [:update, :destroy]
		def index
			@coupons = Coupon.all
		end

		def create 
			@coupon = Coupon.new
			save_coupon!
		end

		def update
			save_coupon!
		end

		def destroy
			@coupon.destroy!
		end

		private 
	
		def coupon_params
			return {} unless params.has_key?(:coupon)
			params.require(:coupon).permit(:code, :due_date, :status, :discount_value)
		end

		def load_coupon
			@coupon = Coupon.find(params[:id])
		end

		def save_coupon!
			@coupon.attributes = coupon_params
			@coupon.save!
			render :show
		rescue
			render_error(fields: @coupon.errors.messages)
		end

	end
end

