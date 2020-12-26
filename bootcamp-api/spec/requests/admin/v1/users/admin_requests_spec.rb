RSpec.describe "Admin V1 User as admin", type: :request do
	let(:user){ create(:user) }

	describe "GET /users" do
		let(:url){ "/admin/v1/users"}
		let!(:users){ create_list(:user, 2) }

		it "returns http success" do
			get url, headers: auth_header(user)
			expect(response).to have_http_status(:ok)
		end

		it "returns all users" do
			users.append(user)
			get url, headers: auth_header(user)
			expect(body_json['users']).to contain_exactly *users.as_json(only: %i(name email profile))
		end
	end

	describe "POST /users" do
		let(:url){"/admin/v1/users"}

		context "with valid params" do
			let!(:user_params){ {user: attributes_for(:user)}.to_json }

			it "should create a new user" do
				expect do
					post url, headers: auth_header(user), params: user_params
				end.to change(User, :count).by(2)
			end

			it "returns last added user" do
				post url, headers: auth_header(user), params: user_params
				expect_user = User.last.as_json(only: %i(name email profile ))
				expect(body_json['user']).to eq expect_user
			end

			it "returns success status" do
				post url, headers: auth_header(user), params: user_params
				expect(response).to have_http_status(:ok)
			end
		end

		context "with invalid params" do
			let!(:user_invalid_params) do
				{ user: attributes_for(:user, name: nil)}.to_json
			end

			it "does not add User" do
				expect do
					post url, headers: auth_header(user), params: user_invalid_params
				end.to change(User, :count).by(1)
			end

			it "return error message" do
				post url, headers: auth_header(user), params: user_invalid_params
				expect(body_json["errors"]["fields"]).to have_key('name')
			end

			it "returns unprocessable_entity status" do
				post url, headers: auth_header(user), params: user_invalid_params
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	end

	describe "PATCH /users/:id" do
		let!(:user_test){ create(:user) }
		let(:url){"/admin/v1/users/#{user_test.id}"}

		context "with valid params" do
			let(:new_name){ "Jorge" }
			let!(:user_params){ {user: {name: new_name }}.to_json }

			it "updates User" do
				patch url, headers: auth_header(user), params: user_params
				user_test.reload
				expect(user_test.name).to eq new_name
			end

			it "returns updates user" do
				patch url, headers: auth_header(user), params: user_params
				user_test.reload
				user_expect = user_test.as_json(only: %i(name email password profile))
				expect(body_json['user']).to eq user_expect
			end

			it "returns success status" do 
				patch url, headers: auth_header(user), params: user_params
				expect(response).to have_http_status(:ok)
			end
		end

		context "with invalid params" do
			let!(:new_invalid_name){ nil }
			let(:user_invalid_params){ {user: attributes_for(:user, name: new_invalid_name)}.to_json }

			it "does not update User" do
				old_user_name = user_test.name
				patch url, headers: auth_header(user), params: user_invalid_params
				user_test.reload
				expect(user_test.name).to eq old_user_name
			end

			it "returns error message" do
				patch url, headers: auth_header(user), params: user_invalid_params
				expect(body_json["errors"]["fields"]).to have_key("name")
			end

			it "returns unprocessable_entity" do
				patch url, headers: auth_header(user), params: user_invalid_params
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	end

	describe "DELETE /coupons/:id" do
		let!(:user_test){ create(:user) }
		let(:url){ "/admin/v1/users/#{user_test.id}"}

		it "removes coupon" do
			expect do
				delete url, headers: auth_header(user)
			end.to change(User, :count).by(0)
		end

		it "returns success status" do
			delete url, headers: auth_header(user)
			expect(response).to have_http_status(:no_content)
		end

		it "does not return any body content" do
			delete url, headers: auth_header(user)
			expect(body_json).to_not be_present
		end
	end
end