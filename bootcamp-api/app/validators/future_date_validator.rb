class FutureDateValidator < ActiveModel::EachValidator
	def initialize(message)
		super
		@message = options[:message] || :future_date
	end	

	def validate_each(record, attribute, value)
		if value.present? && value <= Time.zone.now	
			record.errors.add attribute, @message 
		end
	end
end