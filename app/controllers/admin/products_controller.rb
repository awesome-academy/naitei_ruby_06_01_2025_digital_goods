class Admin::ProductsController < ApplicationController
  before_action :logged_in_user, :admin_user, only: :index

  def index
    @total_stock = Product.total_stock
    @sold_out_count = Product.sold_out_count
    @level = params[:level]&.to_i || 0
    @path = params[:path].to_s

    @categories_lv1 = Category.with_level(1)

    set_category_data if @level.between?(1, 3)

    @products = if [1, 2, 3].include?(@level)
                  Product.product_by_subcategories(@path)
                else
                  Product.all
                end

    respond_to do |format|
      format.turbo_stream
      format.html{render "index"}
    end
  end

  private

  def set_category_data
    path_parts = @path.split("/")

    if @level < 3
      instance_variable_set("@categories_lv#{@level + 1}",
                            Category.with_level(@level + 1, @path))
    end
    instance_variable_set("@category_lv#{@level}_name",
                          Category.find_category_name(@path))

    (@level - 1).downto(1) do |lvl|
      parent_path = path_parts[0..lvl].join("/")
      instance_variable_set("@categories_lv#{lvl + 1}",
                            Category.with_level(lvl + 1, parent_path))
      instance_variable_set("@category_lv#{lvl}_name",
                            Category.find_category_name(parent_path))
    end
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
