RSpec.describe "Admin V1 User without authentication" do

	context "GET /user" do
		let(:url){ "/admin/v1/users"}
		let!(:user_test){ create_list(:user, 5) }
		before(:each) { get url }
		include_examples "unauthenticated access"
	end
	
	context "POST /users" do
		let(:url){ '/admin/v1/users' }
		before(:each) { post url }
		include_examples "unauthenticated access"
	end
	
	context "PATCH /users/:id" do
		let!(:user_test){ create(:user)}
		let(:url){ "/admin/v1/users/#{user_test.id}"}
		before(:each) { patch url }
		include_examples "unauthenticated access"
	end
	
	context "DELETE /users/:id" do
		let!(:user_test){ create(:user)}
		let(:url){ "/admin/v1/users/#{user_test.id}"}
	
		before(:each) { delete url}
		include_examples "unauthenticated access"
	end

end