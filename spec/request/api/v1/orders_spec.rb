require "rails_helper"

RSpec.describe "Api::V1::Orders", type: :request do
  let(:user) { create(:user) }
  let(:province) { create(:province) }
  let(:district) { create(:district, province: province) }
  let(:ward) { create(:ward, district: district) }
  let(:user_address) { create(:user_address, :default, user: user, province: province, district: district, ward: ward) }
  let(:product) { create(:product) }
  let(:cart_item) { create(:cart_item, :default, user: user, product: product) }
  let(:order) { create(:order, user: user, user_address: user_address, status: 3, total_price: 100, delivery_fee: 10) }
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }

  before do
    sign_in user
  end

  describe "GET /api/v1/orders/new" do
    it "returns the delivery address" do
      user_address
      get "/api/v1/orders/new", headers: headers
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["delivery_address"]).to be_present
    end
  end

  describe "POST /api/v1/orders" do
    context "when order creation is successful" do
      before do
        user_address
        cart_item
        post "/api/v1/orders", headers: headers
      end

      it "returns the newly created order" do
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(Order.last.id)
        expect(json_response["status"]).to eq("pending")
      end

      it "creates an order with correct data from create_order" do
        new_order = Order.last
        expect(new_order.user_id).to eq(user.id)
        expect(new_order.user_address_id).to eq(user_address.id)
        expect(new_order.status).to eq("pending")
        expect(new_order.delivery_fee).to eq(Settings.default.order.delivery_fee)
      end

      it "creates order items from cart via create_order_items" do
        order_item = OrderItem.last
        expect(order_item.product_id).to eq(cart_item.product_id)
        expect(order_item.quantity).to eq(cart_item.quantity)
      end

      it "deletes cart items via clear_cart" do
        expect(CartItem.where(user_id: user.id, checked: true)).to be_empty
      end
    end

    context "when the cart is empty from load_cart_data" do
      before do
        CartItem.destroy_all
        post "/api/v1/orders", headers: headers
      end

      it "returns an unprocessable_entity error" do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq(I18n.t("flash.order.please_select_product"))
      end
    end

    context "when order creation fails" do
      before do
        user_address
        cart_item
        allow_any_instance_of(Order).to receive(:persisted?).and_return(false)
        allow_any_instance_of(Order).to receive(:errors).and_wrap_original do |original_method, *args|
          errors = original_method.call
          errors.add(:base, "Creation failed") unless errors.any?
          errors
        end
        post "/api/v1/orders", headers: headers
      end

      it "returns an unprocessable_entity error" do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to be_present
        expect(json_response["errors"]).to include("Creation failed")
      end
    end

    context "when there is an error in the transaction" do
      before do
        user_address
        cart_item
        allow(Order).to receive(:create!).and_raise(StandardError, "Something went wrong")
        post "/api/v1/orders", headers: headers
      end

      it "returns an unprocessable_entity error" do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Something went wrong")
      end
    end

    context "when authorization fails" do
      before do
        user_address
        cart_item
        allow_any_instance_of(Api::V1::OrdersController).to receive(:authorize!).and_raise(CanCan::AccessDenied)
        post "/api/v1/orders", headers: headers
      end

      it "returns unauthorized error" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /api/v1/orders/history_order" do
    let!(:order_pending) { create(:order, user: user, status: 1) }
    let!(:order_delivered) { create(:order, user: user, status: 4) }

    it "returns a list of orders by status" do
      get "/api/v1/orders/history_order", params: { status: "pending" }, headers: headers
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      order_ids = json_response.map { |o| o["id"] }
      expect(order_ids).to include(order_pending.id)
      expect(order_ids).not_to include(order_delivered.id)
    end

    context "when authorization fails" do
      before do
        allow_any_instance_of(Api::V1::OrdersController).to receive(:authorize!).and_raise(CanCan::AccessDenied)
        get "/api/v1/orders/history_order", params: { status: "pending" }, headers: headers
      end

      it "returns unauthorized error" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /api/v1/orders/find_order" do
    it "returns details of a valid order" do
      get "/api/v1/orders/find_order", params: { order_code: order.id, phone: user.telephone }, headers: headers
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(order.id)
    end

    context "when the phone does not match from valid_order?" do
      it "returns a not_found error" do
        get "/api/v1/orders/find_order", params: { order_code: order.id, phone: "wrong_phone" }, headers: headers
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq(I18n.t("flash.order_lookup.order_not_found"))
      end
    end

    context "when the order does not exist from find_order_by_id" do
      it "returns a not_found error" do
        get "/api/v1/orders/find_order", params: { order_code: "9999", phone: user.telephone }, headers: headers
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq(I18n.t("flash.order_lookup.order_not_found"))
      end
    end

    context "when authorization fails" do
      before do
        allow_any_instance_of(Api::V1::OrdersController).to receive(:authorize!).and_raise(CanCan::AccessDenied)
        get "/api/v1/orders/find_order", params: { order_code: order.id, phone: user.telephone }, headers: headers
      end

      it "returns unauthorized error" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /api/v1/orders/:id" do
    before do
      @order = order 
    end

    it "updates the order status successfully" do
      patch "/api/v1/orders/#{order.id}", params: { current_status: "3" }.to_json, headers: headers
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("delivered")
      expect(order.reload.status).to eq("delivered")
    end

    context "when the update fails" do
      before do
        allow_any_instance_of(Order).to receive(:update).and_return(false)
        allow_any_instance_of(Order).to receive(:errors).and_wrap_original do |original_method, *args|
          errors = original_method.call
          errors.add(:base, "Update failed") unless errors.any?
          errors
        end
        patch "/api/v1/orders/#{order.id}", params: { current_status: "3" }.to_json, headers: headers
      end

      it "returns an unprocessable_entity error" do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to be_present
        expect(json_response["errors"]).to include("Update failed")
      end
    end

    context "when the order does not exist from set_order" do
      it "returns a not_found error" do
        patch "/api/v1/orders/9999", params: { current_status: "3" }.to_json, headers: headers
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq(I18n.t("orders.order_not_found"))
      end
    end
  end
end
