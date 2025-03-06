class AttributeGroup < ApplicationRecord
  has_many :product_attributes, dependent: :destroy

  scope :with_level, lambda {|level, path = nil|
    where(level:)
      .where("path LIKE ? OR path IS NULL", "#{path}/%")
  }
end
