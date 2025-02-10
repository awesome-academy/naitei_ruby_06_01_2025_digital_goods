class UserAddress < ApplicationRecord
  belongs_to :user
  belongs_to :province
  belongs_to :district
  belongs_to :ward
  has_many :orders, dependent: :nullify
end
