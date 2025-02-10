class User < ApplicationRecord
  has_many :user_addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :cart_products, through: :cart_items, source: :product
  has_many :user_favorites, dependent: :destroy
  has_many :favorite_products, through: :user_favorites, source: :product
  has_many :product_comments, dependent: :destroy
end
