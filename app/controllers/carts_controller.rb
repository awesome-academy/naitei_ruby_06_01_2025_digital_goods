class CartsController < ApplicationController
  before_action :load_user, :logged_in_user, :correct_user,
                only: %i(show update destroy create)

  def show
    @cart_products = current_user.cart_products_quantity
  end

  def create
    @cart_item = find_or_build_cart_item

    if @cart_item.save
      redirect_to cart_user_path(current_user)
    else
      redirect_to products_path(id: params[:product_id])
    end
  end

  def update
    @cart_item = current_user.cart_items
                             .find_by(product_id: params[:product_id])
    return head :not_found unless @cart_item

    case params[:operation]
    when "increase"
      increase_quantity
    when "decrease"
      decrease_quantity
    end

    respond_to do |format|
      format.turbo_stream
      format.html{redirect_to cart_user_path(current_user), flash:}
    end
  end

  def destroy
    @cart_item = current_user.cart_items
                             .find_by(product_id: params[:product_id])
    return head :not_found unless @cart_item

    product_id = @cart_item.product_id
    @cart_item.destroy

    render turbo_stream: turbo_stream.remove("cart-item-#{product_id}")
  end

  def update_checked
    checked_cart_items = params[:checked_cart_items]&.split(",")&.map(&:to_i)

    if checked_cart_items.blank?
      flash[:waring] = t "flash.cart.select_at_least_one_product"
      redirect_to cart_user_path(current_user) and return
    end

    CartItem.update_all(checked: false)
    current_user.cart_items.where(id: checked_cart_items)
                .update_all(checked: true)
    redirect_to new_order_path
  end

  private

  def increase_quantity
    if @cart_item.quantity < @cart_item.product.stock_quantity
      @cart_item.update(quantity: @cart_item.quantity + 1)
    else
      flash.now[:error] = t "flash.cart.stock_exceeded"
    end
  end

  def decrease_quantity
    if @cart_item.quantity > 1
      @cart_item.update(quantity: @cart_item.quantity - 1)
    else
      product_id = @cart_item.product_id
      @cart_item.destroy
      render turbo_stream: turbo_stream.remove("cart-item-#{product_id}")
    end
  end

  def find_or_build_cart_item
    current_user.cart_items
                .find_or_initialize_by(product_id: params[:product_id])
                .tap do |item|
      item.quantity = item.new_record? ? 1 : item.quantity + 1
    end
  end
end
