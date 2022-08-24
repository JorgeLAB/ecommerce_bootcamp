module Admin
  class ModelLoadingService

    attr_reader :records, :pagination

    def initialize(searchable_model, params)
      @searchable_model = searchable_model
      @params = params || {}
      @records = []
      @pagination = { page: @params[:page].to_i, length: @params[:length].to_i }
    end

    def call
      set_pagination_values
      filtered = search_records(@searchable_model)
      @records = filtered.order(@params[:order].to_h).paginate( @params[:page], @params[:length] )
      set_pagination_attributes(filtered.count)
    end

    private

    def set_pagination_values
      @params[:page] = @params[:page].to_i
      @params[:length] = @params[:length].to_i
      @params[:page] = @searchable_model.model::DEFAULT_PAGE if @pagination[:page] <= 0
      @params[:length] = @searchable_model.model::MAX_PER_PAGE if @pagination[:length] <= 0
    end

    def set_pagination_attributes(total_filtered)
      total_pages = (total_filtered / @params[:length].to_f).ceil
      @pagination.merge!(page: @params[:page], length: @records.count,
                         total: total_filtered, total_pages: total_pages)
    end

    def search_records(searched)
      return searched unless @params.has_key?(:search)

      @params[:search].each do |key, value|
        searched = searched.like(key, value)
      end

      searched
    end

    def set_search_by_name
      # adaptation
      return @searchable_model.like(@params.dig(:search, :name), @params.dig(:search, :name)) if @searchable_model.respond_to?(:search_by_name)
      @searchable_model
    end

  end
end
