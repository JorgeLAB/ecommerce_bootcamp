RSpec.describe "Admin V1 SystemRequirement as :admin" do
	let(:user){ create(:user)}

	context "GET /system_requirements" do
		let(:url) { "/admin/v1/system_requirements"}
		let!(:system_requirements) {create_list(:system_requirement, 5)}
		before(:each){ get url, headers: auth_header(user) }

		it "returns all the system_requirements" do
			expected_records = system_requirements.as_json(only: %i(name operational_system storage processor memory video_board))
			expect(body_json['system_requirements']).to contain_exactly *expected_records
		end

		it "returns success status" do
			expect(response).to have_http_status(:ok)
		end
	end

	context "POST /system_requirements" do
		let(:url){"/admin/v1/system_requirements"}

		context "with valid params" do
			let!(:system_requirements_params){ { system_requirement:  attributes_for(:system_requirement) }.to_json }
			before(:each){ post url, headers: auth_header(user), params: system_requirements_params }

			it "should create a new system_requirement" do
				expect(SystemRequirement.count).to eq 1
			end

			it "returns last added SystemRequirement" do
				expected_records = SystemRequirement.last.as_json(only: %i(name operational_system storage processor memory video_board))
				expect(body_json['system_requirement']).to contain_exactly *expected_records
			end

			it "returns success status" do
				expect(response).to have_http_status(:ok)
			end
		end

		context "with invalid params" do
			let!(:system_requirements_invalid_params){ { system_requirement:  attributes_for(:system_requirement, name: nil) }.to_json }
			before(:each){ post url, headers: auth_header(user), params: system_requirements_invalid_params }

			it "does not add SystemRequirement" do
				expect(SystemRequirement.count).to eq 0
			end

			it "returns error message" do
				expect(body_json['errors']['fields']).to have_key('name')
			end

			it "returns unprocessable_entity status" do
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	end

	context "PATCH /system_requirements/:id" do
		let(:system_requirement){ create(:system_requirement)}
		let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}"}

		context "with valid params" do
			let(:new_name){ "Advance"}
			let!(:system_requirement_params){ {system_requirement: { name: new_name } }.to_json }
			before(:each) { patch url, headers: auth_header(user), params: system_requirement_params }

			let "updates SystemRequirement" do
				system_requirement.reload
				expect(system_requirement.name).to eq new_name
			end

			let "returns updates SystemRequirement" do
				system_requirement.reload
				expected_system_requirement = system_requirement.as_json(only: %i(name operational_system storage processor memory video_board) )
				expect(body_json['system_requirement']).to contain_exactly expected_system_requirement
			end

			it "returns success status" do
				expect(response).to have_http_status(:ok)
			end
		end

		context "with invalid params" do
			let(:system_requirement_invalid_params){ {system_requirement: { name: nil } }.to_json }
			
			it "does not updates SystemRequirement" do
				old_name = system_requirement.name
				patch url, headers: auth_header(user), params: system_requirement_invalid_params
				system_requirement.reload
				expect(system_requirement.name).to eq old_name
			end

			it "returns error message" do
				patch url, headers: auth_header(user), params: system_requirement_invalid_params
				expect(body_json['errors']['fields']).to have_key('name')
			end

			it "returns unprocessably_entity status" do
				patch url, headers: auth_header(user), params: system_requirement_invalid_params
				expect(response).to have_http_status(:unprocessable_entity)
			end		
		end
	end

	context "DELETE /system_requirements/:id" do
		let!(:system_requirement){ create(:system_requirement) }
		let(:url){ "/admin/v1/system_requirements/#{system_requirement.id}"}

		it "removes system_requirement" do
			expect do
				delete url, headers: auth_header(user)
			end.to change(SystemRequirement, :count).by(-1)
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