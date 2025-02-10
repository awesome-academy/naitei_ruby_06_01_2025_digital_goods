class Order < ApplicationRecord
  belongs_to :user
  belongs_to :user_address
  has_many :order_items, dependent: :destroy
  has_many :order_journeys, dependent: :destroy
  has_many :products, through: :order_items, source: :product
end
