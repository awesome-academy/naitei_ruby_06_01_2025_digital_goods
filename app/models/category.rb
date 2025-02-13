class Category < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories, source: :product

  scope :sub_categories_of, lambda {|category_path|
    where("path LIKE ?", "#{category_path}/%")
  }
end
