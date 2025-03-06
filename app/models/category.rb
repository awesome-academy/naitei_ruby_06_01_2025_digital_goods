class Category < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories, source: :product

  scope :sub_categories_of, lambda {|category_path|
    where("path = ? OR path LIKE ?", category_path, "#{category_path}/%")
  }

  scope :with_level, lambda {|level, path = nil|
    where(level:)
      .where("path LIKE ? OR path IS NULL", "#{path}/%")
  }

  scope :find_category_name, ->(path){where(path:).pick(:name)}

  scope :children_of, lambda {|path, level|
    where("path LIKE ? AND level = ?",
          "#{path}/%", level + 1)
  }

  def subcategories
    self.class.children_of(path, level)
  end
end
