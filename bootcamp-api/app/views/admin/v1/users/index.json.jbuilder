json.users do
	json.array! @loading_service.records, :name, :email, :profile
end