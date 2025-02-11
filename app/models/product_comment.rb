class ProductComment < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :parent_comment, class_name: "ProductComment", optional: true
  has_many :replies, class_name: "ProductComment",
    foreign_key: "parent_comment_id", dependent: :destroy
end
