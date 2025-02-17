class ProductsController < ApplicationController
  include StaticPagesHelper

  def show
    @product = Product.find_by(id: params[:id])
    unless @product
      flash[:alert] = t "view.product_detail.product_not_found"
      redirect_to root_path
    end
    @similar_products = Product.similar_products(@product)
  end
end
