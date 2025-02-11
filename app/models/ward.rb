class Ward < ApplicationRecord
  belongs_to :district
  has_many :user_addresses, dependent: :destroy
  has_many :order_journeys, dependent: :nullify
end
