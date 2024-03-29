RSpec.describe "Admin V1 Categories as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "GET /categories" do
    let(:url){ "/admin/v1/categories" }
    let!(:categories){ create_list(:category, 3) }

    before(:each) { get url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

  context "POST /categories" do
    let(:url) { "/admin/v1/categories"}

    before(:each) { post url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

  context 'GET /categories/:id' do
    let!(:category){ create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}"}

    before(:each) { get url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

  context "PATCH /categories" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}"}

    before(:each) { patch url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

  context "DELETE /categories" do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}"}

    before(:each) { delete url, headers: auth_header(user) }
    include_examples "forbidden access"
  end

end
