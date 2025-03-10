class OrdersController < ApplicationController
  before_action :logged_in_user, :load_cart_data, only: %i(new create)
  load_and_authorize_resource only: %i(update destroy)
  include OrdersHelper
  include CartsHelper

  def new
    @delivery_address = current_user.default_address
  end

  def create
    authorize_resources
    _, success = process_order_creation
    redirect_after_create success
  end

  def authorize_resources
    authorize! :create, Order
    authorize! :create, OrderItem
    authorize! :manage, CartItem, user_id: current_user.id
  end

  def process_order_creation
    order = nil
    success = false

    begin
      ActiveRecord::Base.transaction do
        order = create_order
        create_order_items(order)

        if order.persisted?
          clear_cart
          success = true
        else
          flash[:warning] = t("flash.order.creation_failed")
          raise ActiveRecord::Rollback
        end
      end
    rescue StandardError => e
      flash[:error] = t("flash.order.error_occurred", error: e.message)
    end

    [order, success]
  end

  def show_track; end

  def history_order
    authorize! :history_order, Order
    status = Settings.default.order.order_status[params[:status].to_s]
    @user_orders = current_user.orders_by_status(status)
    @current_status = params[:status]
    respond_to do |format|
      format.turbo_stream
      format.html{render "history_order"}
    end
  end

  def find_order
    @order = find_order_by_id params[:order_code]
    authorize! :find_order, @order if @order
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

  def update
    after_status = params[:current_status].to_i + 1
    if @order.update(status: after_status)
      handle_successful_update(params[:current_status].to_i)
    else
      flash.now[:error] = t "view.user.update_failed"
    end
  end

  private

  def find_order_by_id order_code
    Order.find_by(id: order_code)
  end

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

  def redirect_after_create success
    if success
      flash[:success] = t("flash.order.created_successfully")
      redirect_to root_path and return
    else
      @delivery_address = current_user.default_address
      render :new
    end
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

  def handle_successful_update current_status
    @user_orders = current_user.orders_by_status(current_status)
    respond_to do |format|
      format.turbo_stream{render "history_order"}
      format.html{render "history_order"}
    end
  end
end
