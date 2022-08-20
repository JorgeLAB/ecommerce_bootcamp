RSpec.describe "Admin V1 Licenses as admin", type: :request do
  let(:user) { create(:user) }

  context 'GET /licenses' do
    let(:url) { '/admin/v1/licenses'}
    let!(:licenses) { create_list(:license, 10) }

    context "without any params" do

      it "returns 10 Licenses" do
        get url, headers: auth_header(user)
        expect(body_json['licenses'].count).to eq 10
      end

      it "returns 10 first Categories" do
        get url, headers: auth_header(user)
        expected_licenses = licenses[0..9].as_json(only: %i(id key))
        expect(body_json['licenses']).to contain_exactly *expected_licenses
      end

      it "returns success status" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user) }
      end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(user), params: pagination_params
        expect(body_json['licenses'].count).to eq length
      end

      it "returns licenses limit by pagination" do
        get url, headers: auth_header(user), params: pagination_params
        expected_licenses = licenses[5..9].as_json( only: %i(id key ))
        expect(body_json['licenses']).to contain_exactly *expected_licenses
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 2, length: 5, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: pagination_params }
      end
    end

    context "with order params" do
      let(:order_params) { { order: {key: 'desc'} } }

      it "returns ordered licenses limit by default pagination" do
        get url, headers: auth_header(user), params: order_params
        licenses.sort! {|a,b| b[:key] <=> a[:key] }
        expected_licenses = licenses[0..9].as_json(only: %i(id key))
        expect(body_json['licenses']).to contain_exactly *expected_licenses
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user), params: order_params }
      end
    end
  end

  context 'POST /licenses' do
    let(:url) { '/admin/v1/licenses'}

    context 'when params are valid' do
      let(:user) { create(:user) }
      let!(:license_params) { { license: { user_id: user.id } }.to_json }

      it 'adds a new License' do
        expect do
          post url, headers: auth_header(user), params: license_params
        end.to change(License, :count).by(1)
      end

      it 'returns last added License' do
        post url, headers: auth_header(user), params: license_params
        expect_license = License.last.as_json(only: %i(id key))
        expect(body_json['license']).to eq expect_license
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when params are invalid' do
      let!(:license_invalid_params){ {license: attributes_for(:license, user_id: nil) }.to_json }

      it 'does not add new License' do
        expect do
          post url, headers: auth_header(user), params: license_invalid_params
        end.to_not change(License, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['errors']['fields']).to eq("Couldn't find User without an ID")
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'GET /categories/:id' do
    let!(:category){ create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}"}

    it "returns requested category" do
      get url, headers: auth_header(user)
      expected_category = category.as_json(only: %i(id name))
      expect(body_json['category']).to contain_exactly *expected_category
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'PATCH /categories/:id' do
    let!(:category) {create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}"}

    context 'with valid params' do
      let(:new_name) { 'Adventure' }
      let(:category_params) { { category: { name: new_name } }.to_json }

      it 'updates Category' do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect(category.name).to eq new_name
      end

      it 'returns updated Category' do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expected_category = category.as_json(only: %i(id name))
        expect(body_json['category']).to eq expected_category
      end

      it 'returns success Category' do
        patch url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:category_invalid_params) { {category: attributes_for(:category, name: nil) }.to_json }

      it "does not update Category" do
        old_name = category.name
        patch url, headers: auth_header(user), params: category_invalid_params
        category.reload
        expect(category.name).to eq old_name
      end

      it "returns error message" do
        patch url, headers: auth_header(user), params: category_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it "returns unprocessable_entity status" do
        patch url, headers: auth_header(user), params: category_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  context 'DELETE /categories/:id' do
    let!(:category) { create(:category) }
    let(:url){ "/admin/v1/categories/#{category.id}" }

    it "removes Category" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Category, :count).by(-1)
    end

    it "return success status" do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it "does not return any body content" do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end

    it "removes all associated product categories" do
      product_categories = create_list(:product_category, 3, category: category)
      delete url, headers: auth_header(user)
      expected_product_category = ProductCategory.where( id: product_categories.map(&:id) )
      expect(expected_product_category.count).to eq 0
    end

    it "does not remove unassociated product categories" do
      product_categories = create_list(:product_category,3)
      delete url, headers: auth_header(user)
      present_product_categories_ids = product_categories.map(&:id)
      expected_product_category = ProductCategory.where(id: present_product_categories_ids)
      expect(expected_product_category.ids).to contain_exactly(*present_product_categories_ids)
    end
  end
end
