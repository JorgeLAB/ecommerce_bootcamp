json.users do
	json.array! @users, :name, :email, :profile
end