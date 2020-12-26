RSpec.describe "Admin V1 User as :client" do
	let(:user){ create(:user, profile: :client) }

	context "GET /users" do
		let(:url){"/admin/v1/users"}
		let(:users){ create_list(:user, 8)}
		before(:each){ get url, headers: auth_header(user) }
		include_examples "forbidden access"
	end

	context "POST /users" do
		let(:url){ "/admin/v1/users" }
		let!(:user_params){ {user: attributes_for(:user)}.to_json }
		before(:each){ get url, headers: auth_header(user), params: user_params}
		include_examples "forbidden access"
	end

	context "PATCH /users/:id" do
		let(:user_test){ create(:user) }
		let(:url){ "/admin/v1/users/#{user_test.id}" }
		let(:user_params){ {user: {name: 'Lin' }}.to_json }
		before(:each){ patch url, headers: auth_header(user), params: user_params}
		include_examples "forbidden access"		
	end

	context "DELETE /users/:id" do
		let(:user_test){ create(:user) }
		let(:url){ "/admin/v1/users/#{user_test.id}" }

		before(:each){ delete url, headers: auth_header(user) }
		include_examples "forbidden access"
	end		
end