module Admin::OrdersHelper
  def full_address order
    [
      order.user_address[:location],
      order.user_address.ward[:name],
      order.user_address.district[:name],
      order.user_address.province[:name]
    ].compact.join(", ")
  end

  def order_status_admin
    {
      "canceled" => {label: t("view.order_lookup.status_canceled"),
                     css_class: "order-status-canceled", icon: "x-circle"},
      "pending" => {label: t("view.order_lookup.status_pending"),
                    css_class: "order-status-pending", icon: "hourglass-split"},
      "picking" => {label: t("view.order_lookup.status_confirmed"),
                    css_class: "order-status-picking", icon: "box-seam"},
      "shipping" => {label: t("view.admin.order.delivering_to_customer"),
                     css_class: "order-status-shipping", icon: "truck"},
      "delivered" => {label: t("view.order_lookup.status_delivered"),
                      css_class: "order-status-delivered", icon: "check-circle"}
    }
  end

  def order_status_tag_admin order
    status_info = order_status_admin[order.status]
    return unless status_info

    content_tag(:div, status_info[:label], class: status_info[:css_class])
  end

  def order_status_tag_update order
    status_info = order_status_admin[order.status]
    return unless status_info

    button_text = determine_button_text(order)

    if button_text
      button_to button_text,
                admin_order_path(order,
                                 current_status: order.status_before_type_cast),
                method: :patch,
                class: status_info[:css_class]
    else
      content_tag(:div, status_info[:label], class: status_info[:css_class])
    end
  end

  private

  def determine_button_text order
    case order.status_before_type_cast
    when Settings.default.order.order_status.pending
      t("view.admin.order.confirm")
    when Settings.default.order.order_status.picking
      t("view.admin.order.start_shipping")
    when Settings.default.order.order_status.shipping
      t("view.admin.order.user_received")
    end
  end
end
