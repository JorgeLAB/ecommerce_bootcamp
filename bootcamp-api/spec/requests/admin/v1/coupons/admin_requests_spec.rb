RSpec.describe "Admin V1 Coupon as admin" do 
  let(:user) { create(:user) }

  context "GET /coupons" do
    let(:url) { "/admin/v1/coupons"}
    let!(:coupons) { create_list(:coupon, 5)}

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end

    it "return all the coupons" do
      get url, headers: auth_header(user)
      expected_records = coupons.as_json(only: %i(code due_date discount_value status) )
      expect(body_json['coupons']).to contain_exactly *expected_records
    end
  end

  context "POST /coupons" do
    let(:url) {"/admin/v1/coupons"}

    context "with valid params" do
      let!(:coupon_params) { {coupon: attributes_for(:coupon)}.to_json }
      before(:each){ post url, headers: auth_header(user), params: coupon_params }

      it "should create a new coupon" do
        expect(Coupon.count).to eq 1
      end

      it "returns last added coupon" do
        expect_coupon = Coupon.last.as_json(only: %i(code due_date discount_value status))
        expect(body_json['coupon']).to eq   expect_coupon
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:coupon_invalid_params) { {coupon: attributes_for(:coupon, code: nil)}.to_json }
      before(:each){ post url, headers: auth_header(user), params: coupon_invalid_params }

      it "does not add Coupon" do
        expect(Coupon.count).to eq 0
      end

      it "return error message" do
        expect(body_json['errors']['fields']).to have_key('code')
      end

      it "returns unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "PATCH /coupons/:id" do
    let!(:coupon){ create(:coupon)}
    let(:url) { "/admin/v1/coupons/#{ coupon.id }" }

    context "with params valid" do
      let(:new_discount_value){ 42.22 }
      let(:coupon_params){ {coupon: {discount_value: new_discount_value }}.to_json }
      before(:each){ patch url, headers: auth_header(user), params: coupon_params }

      it "updates Coupon" do
        coupon.reload
        expect(coupon.discount_value).to eq new_discount_value
      end

      it "returns updates coupon" do
        coupon.reload
        expected_record = coupon.as_json(only: %i(code due_date discount_value status))
        expect(body_json['coupon']).to eq expected_record
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with params invalid" do
      let!(:coupon_invalid_params){ {coupon: {discount_value: nil }}.to_json }
      let!(:old_value_coupon) { coupon.discount_value }
      before(:each){ patch url, headers: auth_header(user), params: coupon_invalid_params }

      it "does not updates Coupon" do
        coupon.reload
        expect(coupon.discount_value).to eq old_value_coupon
      end

      it "returns error message" do
        expect(body_json['errors']['fields']).to have_key("discount_value")
      end

      it "returns unprocessable_entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /coupons/:id" do
    let!(:coupon){ create(:coupon) }
    let(:url){ "/admin/v1/coupons/#{coupon.id}"}

    it "removes coupon" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Coupon, :count).by(-1)
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
