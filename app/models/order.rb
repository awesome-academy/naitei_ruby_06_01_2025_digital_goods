class Order < ApplicationRecord
  belongs_to :user
  belongs_to :user_address
  has_many :order_items, dependent: :destroy
  has_many :order_journeys, dependent: :destroy
  has_many :products, through: :order_items, source: :product

  enum status: {
    canceled: Settings.default.order.order_status.canceled,
    pending: Settings.default.order.order_status.pending,
    picking: Settings.default.order.order_status.picking,
    shipping: Settings.default.order.order_status.shipping,
    delivered: Settings.default.order.order_status.delivered
  }

  def order_product
    order_items.includes(:product)
  end
end
