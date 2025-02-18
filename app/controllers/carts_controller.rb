class CartsController < ApplicationController
  before_action :load_user, :logged_in_user, :correct_user, only: :show

  def show
    @cart_products = current_user.cart_products_quantity
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

  private

  def increase_quantity
    if @cart_item.quantity < @cart_item.product.stock_quantity
      @cart_item.update(quantity: @cart_item.quantity + 1)
    else
      flash.now[:alert] = t "flash.cart.stock_exceeded"
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
end
