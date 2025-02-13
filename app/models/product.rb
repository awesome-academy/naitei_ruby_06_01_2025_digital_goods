class Product < ApplicationRecord
  has_one :product_detail, dependent: :destroy
  has_many :product_attributes, dependent: :destroy
  has_many :user_favorites, dependent: :destroy
  has_many :favorite_users, through: :user_favorites, source: :user
  has_many :product_comments, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many_attached :images

  has_many :categories, through: :product_categories, source: :category
  scope :product_by_subcategories, lambda {|category_path|
                               joins(:categories)
                                 .where(categories: {path: Category
                                 .sub_categories_of(category_path)
                                 .select(:path)})
                                 .distinct
                             }
end
