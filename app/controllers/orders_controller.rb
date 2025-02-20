class OrdersController < ApplicationController
  before_action :logged_in_user, :load_cart_data, only: %i(new create)
  include OrdersHelper
  include CartsHelper

  def new
    @delivery_address = current_user.default_address
  end

  def create
    ActiveRecord::Base.transaction do
      order = create_order
      create_order_items(order)
      if order.persisted?
        clear_cart
        flash[:success] = t("flash.order.created_successfully")
        redirect_to root_path and return
      else
        flash[:warning] = t("flash.order.creation_failed")
        raise ActiveRecord::Rollback
      end
    end

    render :new
  end

  def show_track; end

  def find_order
    @order = Order.find_by(id: params[:order_code])

    if valid_order?
      set_order_details
      respond_to do |format|
        format.turbo_stream
        format.html{render "show_track"}
      end
    else
      handle_order_not_found
    end
  end

  private

  def create_order
    Order.create!(
      user: current_user,
      user_address: current_user.default_address,
      total_price: @total_amount,
      delivery_fee: Settings.default.order.delivery_fee,
      status: Settings.default.order.order_status.pending
    )
  end

  def create_order_items order
    @cart_items.each do |cart_item|
      OrderItem.create!(
        order:,
        product: cart_item.product,
        quantity: cart_item.quantity
      )
    end
  end

  def clear_cart
    @cart_items.destroy_all
  end

  def load_cart_data
    @cart_items = CartItem.checked_by_user(current_user.id)
    if @cart_items.empty?
      flash[:error] = t "flash.order.please_select_product"
      redirect_to cart_user_path(current_user) and return
    end
    @products_price = total_price(@cart_items)
    @total_amount = total_amount(@products_price)
  end

  def full_address order
    [
      order.user_address[:location],
      order.user_address.ward[:name],
      order.user_address.district[:name],
      order.user_address.province[:name]
    ].compact.join(", ")
  end

  def valid_order?
    @order&.user&.telephone == params[:phone]
  end

  def set_order_details
    @order_products = @order.order_product
    @total_price = total_price(@order_products)
    @total_amount = total_amount(@total_price)
    @user_order = User.find_by(id: @order[:user_id])
    @location = full_address(@order)
  end

  def handle_order_not_found
    respond_to do |format|
      format.turbo_stream{head :no_content}
      format.html do
        flash[:error] = t("flash.order_lookup.order_not_found")
        render "show_track"
      end
    end
  end
end
