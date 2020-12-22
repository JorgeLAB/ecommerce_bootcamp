module RequestAPI
	def body_json(symbolize_key: false)
		json = JSON.parse(response.body)
		symbolize_keys ? json.deep_symbolize_keys : json
	rescue
		return {}
	end

	# method returns authentication header

	def auth_header( user = nil, merge_with: {} )
		user ||= create(:user)
		auth = user.create_new_auth_token
		header = auth.merge({'Content-Type' => 'application/json', 'Accept' => 'application/json' })
		header.merge merge_with
	end
end

# include this module in rspec processor. Only to the type request

RSspec.configure do |config|
	config.include RequestAPI, type: :request
end
