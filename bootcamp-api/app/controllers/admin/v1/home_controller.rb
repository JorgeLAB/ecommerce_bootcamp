module Admin::V1
  class HomeController < ApiController
    def index
      render json: {message: 'Hello new'}
    end
  end
end
