class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :user

  scope :checked_by_user, lambda {|user_id|
    where(checked: true, user_id:).includes(:product)
  }
end
