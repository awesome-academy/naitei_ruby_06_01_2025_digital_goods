class Admin::OrdersController < ApplicationController
  before_action :logged_in_user, :admin_user, only: :index
  include Admin::OrdersHelper

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

  private

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def filtered_orders
    Order.by_status(params[:status])
  end
end
