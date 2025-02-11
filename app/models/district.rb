class District < ApplicationRecord
  belongs_to :province
  has_many :wards, dependent: :destroy
  has_many :user_addresses, dependent: :destroy
  has_many :order_journeys, dependent: :nullify
end
