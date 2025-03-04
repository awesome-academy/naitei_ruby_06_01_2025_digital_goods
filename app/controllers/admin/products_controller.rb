class Admin::ProductsController < ApplicationController
  before_action :logged_in_user, :admin_user, only: :index

  def index
    set_instance_variables
    set_category_data if @level.between?(1, 3)
    set_products

    respond_to do |format|
      format.turbo_stream
      format.html{render "index"}
    end
  end

  def create
    ActiveRecord::Base.transaction do
      product = create_product_with_details
      create_product_attributes(product)
      create_product_categories(product)

      flash[:success] = t("view.admin.product.created_success")
      redirect_to root_path
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = t("view.admin.product.error_message", message: e.message)
      redirect_to admin_products_path
    end
  end

  def select_category
    category_id = params[:category_id]
    @category = Category.find_by(id: category_id)
    if @category
      @category_lv1_name = @category[:name]
      @subcategories = @category.subcategories
      respond_to do |format|
        format.turbo_stream
        format.html{render "index"}
      end
    else
      flash[:alert] = t("view.admin.product.category_not_found")
      redirect_to admin_products_path
    end
  end

  def save_category_session
    session[:selected_categories] ||= []
    category_id = params[:category_id].to_i
    category_path = params[:category_path]
    root_prefix_path, new_path_prefix = extract_paths(category_path)

    if root_prefix_path.present?
      handle_existing_categories(root_prefix_path, new_path_prefix)
    end

    session[:selected_categories] << {id: category_id, path: category_path}
    head :ok
  end

  private

  def set_instance_variables
    @total_stock = Product.total_stock
    @sold_out_count = Product.sold_out_count
    @attributes = AttributeGroup.with_level 2
    @level = params[:level]&.to_i || 0
    @path = params[:path].to_s
    @categories_lv1 = Category.with_level(1)
  end

  def set_products
    @products = if [1, 2, 3].include?(@level)
                  Product.product_by_subcategories(@path)
                else
                  Product.all
                end
  end

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

  def extract_paths category_path
    root_prefix = category_path.split("/")[1]
    root_prefix_path = root_prefix.present? ? "/#{root_prefix}/" : nil
    new_path_prefix = category_path.rpartition("/").first
    [root_prefix_path, new_path_prefix]
  end

  def handle_existing_categories root_prefix_path, new_path_prefix
    if session[:selected_categories].all? do |cat|
         cat["path"].to_s.start_with?(root_prefix_path)
       end
      session[:selected_categories].reject! do |cat|
        cat["path"].to_s.start_with?(new_path_prefix)
      end
    else
      session[:selected_categories].clear
    end
  end

  def product_params
    params.require(:product).permit(Product::PRODUCT_PARAMS)
  end

  def product_detail_params
    params.require(:product).permit(Product::PRODUCT_DETAIL_PARAMS)
  end

  def create_product_with_details
    product = Product.create!(product_params)
    product.create_product_detail!(product_detail_params)
    product
  end

  def create_product_attributes product
    params[:product][:attributes].each do |attribute_group_id, value|
      product.product_attributes.create!(
        attribute_group_id:,
        value:
      )
    end
  end

  def create_product_categories product
    session[:selected_categories].each do |category|
      product.product_categories.create!(category_id: category["id"])
    end
  end
end
