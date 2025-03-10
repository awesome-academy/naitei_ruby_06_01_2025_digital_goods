class StaticPagesController < ApplicationController
  def home
    authorize! :read, Product
    load_products
  end

  private

  def load_products
    @phone_products = fetch_products(:phone)
    @laptop_products = fetch_products(:laptop)
    @audio_products = fetch_products(:audio)
  end

  def fetch_products category
    category_id = Settings.default.category.public_send("#{category}_id")
    Product.product_by_subcategories("/#{category_id}")
  end
end
