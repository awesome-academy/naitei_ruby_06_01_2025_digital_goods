require "rails_helper"

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:user_address) { create(:user_address, user: user) }
  let(:product) { create(:product) }
  let(:order) { create(:order, user: user, user_address: user_address, status: :pending) }
  let!(:order_item) { create(:order_item, order: order, product: product) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:user_address) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_many(:order_journeys).dependent(:destroy) }
    it { should have_many(:products).through(:order_items) }
  end

  describe "enums" do
    it "defines statuses correctly" do
      expect(Order.statuses).to eq(
        "canceled" => Settings.default.order.order_status.canceled,
        "pending" => Settings.default.order.order_status.pending,
        "picking" => Settings.default.order.order_status.picking,
        "shipping" => Settings.default.order.order_status.shipping,
        "delivered" => Settings.default.order.order_status.delivered
      )
    end
  end

  describe "scopes" do
    let!(:pending_order) { create(:order, status: :pending, user: user, user_address: user_address) }
    let!(:delivered_order) { create(:order, status: :delivered, user: user, user_address: user_address) }

    it ".by_status returns orders with given status" do
      expect(Order.by_status("pending")).to include(pending_order)
      expect(Order.by_status("pending")).not_to include(delivered_order)
    end
  end

  describe "instance methods" do
    describe "#order_product" do
      it "returns associated order_items with products" do
        expect(order.order_product).to include(order_item)
      end
    end
  end
end
