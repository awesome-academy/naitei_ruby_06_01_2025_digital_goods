require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) } 
  let(:province) { create(:province) }
  let(:district) { create(:district, province: province) }
  let(:ward) { create(:ward, district: district) }
  let(:user_address) { create(:user_address, :default, user: user) }
  let(:product) { create(:product) }
  let(:cart_item) { create(:cart_item, :default, user: user, product: product) }
  let(:order) { create(:order, user: user, user_address: user_address) }

  before do
    sign_in user
  end

  describe "GET #new" do
    context "when user has a default address and checked cart items" do
      before do
        user_address
        cart_item
        get :new
      end

      it "assigns the default address to @delivery_address" do
        expect(assigns(:delivery_address)).to eq(user_address)
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end

    context "when cart is empty" do
      before { get :new }

      it "redirects to cart_user_path with error flash" do
        expect(response).to redirect_to(cart_user_path(user))
        expect(flash[:error]).to eq(I18n.t("flash.order.please_select_product"))
      end
    end
  end

  describe "POST #create" do
    before do
      user_address 
      cart_item 
    end

    context "when order creation is successful" do
      it "creates a new order" do
        expect {
          post :create
        }.to change(Order, :count).by(1)
      end

      it "creates order items from cart" do
        expect {
          post :create
        }.to change(OrderItem, :count).by(1)
      end

      it "clears the cart items" do
        post :create
        expect(CartItem.where(user_id: user.id, checked: true)).to be_empty
      end

      it "redirects to root_path with success flash" do
        post :create
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq(I18n.t("flash.order.created_successfully"))
      end
    end

    context "when order creation fails" do
      before do
        allow_any_instance_of(Order).to receive(:persisted?).and_return(false)
      end

      it "renders new template with warning flash" do
        post :create
        expect(response).to render_template(:new)
        expect(flash[:warning]).to eq(I18n.t("flash.order.creation_failed"))
      end
    end

    context 'when an error occurs during transaction' do
      before do
        allow(Order).to receive(:create!).and_raise(StandardError, "Something went wrong")
      end
    
      it 'renders new template with error flash' do
        post :create
        expect(flash[:error]).to eq(I18n.t("flash.order.error_occurred", error: "Something went wrong"))
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #history_order" do
    let!(:order_pending) { create(:order, user: user, status: 1) } 
    let!(:order_delivered) { create(:order, user: user, status: 4) } 

    context "with valid status filter" do
      before do
        get :history_order, params: { status: "pending" }
      end

      it "assigns user's orders with the specified status" do
        expect(assigns(:user_orders)).to include(order_pending)
        expect(assigns(:user_orders)).not_to include(order_delivered)
      end

      it "assigns current_status" do
        expect(assigns(:current_status)).to eq("pending")
      end

      it "renders history_order template" do
        expect(response).to render_template(:history_order)
      end
    end

    context "with turbo_stream format" do
      before { get :history_order, params: { status: "pending", format: :turbo_stream } }
  
      it "responds with turbo_stream" do
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end
  end

  describe "GET #find_order" do
    let(:valid_params) { { order_code: order.id, phone: user.telephone } }
    let(:invalid_phone_params) { { order_code: order.id, phone: "wrong_phone" } }
    let(:invalid_order_params) { { order_code: "9999", phone: user.telephone } }

    context "when order exists and phone matches" do
      before { get :find_order, params: valid_params }

      it "assigns the order" do
        expect(assigns(:order)).to eq(order)
      end

      it "renders show_track template" do
        expect(response).to render_template(:show_track)
      end
    end

    context "when phone does not match" do
      before { get :find_order, params: invalid_phone_params }

      it "responds with error flash" do
        expect(response).to render_template(:show_track)
        expect(flash[:error]).to eq(I18n.t("flash.order_lookup.order_not_found"))
      end
    end

    context "when order does not exist" do
      before { get :find_order, params: invalid_order_params }

      it "responds with error flash" do
        expect(response).to render_template(:show_track)
        expect(flash[:error]).to eq(I18n.t("flash.order_lookup.order_not_found"))
      end
    end

    context "with turbo_stream format" do
      before { get :find_order, params: valid_params.merge(format: :turbo_stream) }
  
      it "responds with turbo_stream" do
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end
  end

  describe "PATCH #update" do
    before do
      allow(controller).to receive(:authorize!).and_return(true)
      @order = order
    end

    context "when update is successful" do
      before { patch :update, params: { id: order.id, current_status: "3" } }

      it "updates the order status" do
        expect(order.reload.status).to eq("delivered")
      end

      it "renders history_order template" do
        expect(response).to render_template(:history_order)
      end
    end

    context "when update fails" do
      before do
        allow_any_instance_of(Order).to receive(:update).and_return(false)
        patch :update, params: { id: order.id, current_status: "3" }
      end

      it "sets error flash" do
        expect(flash.now[:error]).to eq(I18n.t("view.user.update_failed"))
      end
    end
  end
end
