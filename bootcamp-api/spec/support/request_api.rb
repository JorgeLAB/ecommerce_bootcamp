module RequestAPI
	def body_json(symbolize_key: false)
		json = JSON.parse(response.body)
		symbolize_key ? json.deep_symbolize_keys : json
	rescue
		return {}
	end

	# method returns authentication header

	def auth_header( user = nil, merge_with: {} )
		user ||= create(:user)
		auth = user.create_new_auth_token
		header = auth.merge(default_header)
		header.merge merge_with
	end

  def unauthenticated_header(merge_with: {})
    default_header.merge merge_with
  end

  private

  def default_header
    {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end
end

# include this module in rspec processor. Only to the type request

RSpec.configure do |config|
	config.include RequestAPI, type: :request
end
