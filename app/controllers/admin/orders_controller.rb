class Admin::OrdersController < ApplicationController
  before_action :logged_in_user, :admin_user, only: :index
  include Admin::OrdersHelper
  include OrdersHelper
  include CartsHelper

  def index
    @orders = filtered_orders
    @text_filter = order_status_admin[params[:status]]&.dig(:label) ||
                   t("view.admin.order.all")
    @order_counts = Order.group(:status).count
    respond_to do |format|
      format.turbo_stream
      format.html{render "index"}
    end
  end

  def show
    @order = find_order_by_id params[:id]
    set_order_details
    respond_to do |format|
      format.turbo_stream
      format.html{render "index"}
    end
  end

  def update
    @order = find_order_by_id params[:id]
    after_status = params[:current_status].to_i + 1
    if @order.update(status: after_status)
      respond_to do |format|
        format.turbo_stream
        format.html{render "index"}
      end
    else
      flash.now[:error] = t "view.user.update_failed"
    end
  end

  private

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def filtered_orders
    Order.by_status(params[:status])
  end

  def find_order_by_id order_code
    Order.find_by(id: order_code)
  end

  def set_order_details
    @order_products = @order.order_product
    @total_price = total_price(@order_products)
    @total_amount = total_amount(@total_price)
    @user_order = User.find_by(id: @order[:user_id])
    @location = full_address(@order)
  end
end
