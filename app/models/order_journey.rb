class OrderJourney < ApplicationRecord
  belongs_to :order
  belongs_to :province, optional: true
  belongs_to :district, optional: true
  belongs_to :ward, optional: true
end
