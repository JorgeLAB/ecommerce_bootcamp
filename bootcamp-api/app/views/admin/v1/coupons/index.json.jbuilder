json.coupons do
	json.array! @coupons, :code, :due_date, :discount_value , :status  
end