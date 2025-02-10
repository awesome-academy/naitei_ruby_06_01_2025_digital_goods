class Province < ApplicationRecord
  has_many :districts, dependent: :destroy
  has_many :user_addresses, dependent: :destroy
  has_many :order_journeys, dependent: :nullify
end
