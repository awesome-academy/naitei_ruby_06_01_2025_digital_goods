class ProductsController < ApplicationController
  include StaticPagesHelper

  load_and_authorize_resource only: :show

  def show
    unless @product
      flash[:alert] = t "view.product_detail.product_not_found"
      redirect_to root_path and return
    end
    @similar_products = Product.similar_products(@product)
  end
end
