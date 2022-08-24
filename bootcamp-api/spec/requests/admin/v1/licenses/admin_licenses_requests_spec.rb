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

      it "returns 10 first license" do
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

  context 'GET /licenses/:id' do
    let!(:license){ create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}"}

    it "returns requested license" do
      get url, headers: auth_header(user)
      expected_license = license.as_json(only: %i(id key))
      expect(body_json['license']).to contain_exactly *expected_license
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'PATCH /licenses/:id' do
    let!(:license) {create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}"}

    context 'with valid params' do
      let(:new_key) { SecureRandom.hex(10) }
      let(:license_params) { { license: { key: new_key } }.to_json }

      it 'updates License' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect(license.key).to eq new_key
      end

      it 'returns updated license' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expected_license = license.as_json(only: %i(id key))
        expect(body_json['license']).to eq expected_license
      end

      it 'returns success License' do
        patch url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:license_invalid_params) { {license: attributes_for(:license, key: nil) }.to_json }

      it "does not update License" do
        old_key = license.key
        patch url, headers: auth_header(user), params: license_invalid_params
        license.reload
        expect(license.key).to eq old_key
      end

      it "returns error message" do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['errors']['fields']).to eq('A validação falhou: Key não pode ficar em branco')
      end

      it "returns unprocessable_entity status" do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  context 'DELETE /licenses/:id' do
    let!(:license) { create(:license) }
    let(:url){ "/admin/v1/licenses/#{license.id}" }

    it "removes License" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(License, :count).by(-1)
    end

    it "return success status" do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it "does not return any body content" do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end
end
