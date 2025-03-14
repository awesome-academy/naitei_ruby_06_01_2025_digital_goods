class Api::V1::OrdersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, :load_cart_data, only: [:create]
  before_action :set_order, only: [:update]
  include OrdersHelper
  include CartsHelper

  def new
    render json: {delivery_address: current_user.default_address}, status: :ok
  end

  def create
    authorize_resources
    order, success = process_order_creation
    if success
      render json: order, serializer: OrderSerializer, status: :created
    else
      render json: {errors: order.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def history_order
    authorize! :history_order, Order
    status = Settings.default.order.order_status[params[:status].to_s]
    user_orders = current_user.orders_by_status(status)
    render json: user_orders, each_serializer: OrderSerializer, status: :ok
  end

  def find_order
    order = find_order_by_id(params[:order_code])
    authorize! :find_order, order if order
    if order && valid_order?(order)
      render json: order, serializer: OrderSerializer, status: :ok
    else
      render json: {error: I18n.t("flash.order_lookup.order_not_found")},
             status: :not_found
    end
  end

  def update
    after_status = params[:current_status].to_i + 1
    if @order.update(status: after_status)
      render json: @order, serializer: OrderSerializer, status: :ok
    else
      render json: {errors: @order.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find_by(id: params[:id], user_id: current_user.id)
    return if @order

    render json: {error: I18n.t("orders.order_not_found")}, status: :not_found
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

        raise ActiveRecord::Rollback unless order.persisted?

        clear_cart
        success = true
      end
    rescue StandardError => e
      order ||= Order.new
      order.errors.add(:base, e.message)
    end

    [order, success]
  end

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

  def load_cart_data
    @cart_items = CartItem.checked_by_user(current_user.id)
    if @cart_items.empty?
      render json: {error: I18n.t("flash.order.please_select_product")},
             status: :unprocessable_entity
      return
    end
    @products_price = total_price(@cart_items)
    @total_amount = total_amount(@products_price)
  end

  def valid_order? order
    order&.user&.telephone == params[:phone]
  end
end
