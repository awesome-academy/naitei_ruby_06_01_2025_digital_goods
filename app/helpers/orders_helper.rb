module OrdersHelper
  def total_quantity cart_items
    cart_items.sum(&:quantity)
  end

  def total_price cart_items
    cart_items.sum do |cart_item|
      price = cart_item.product[:price]
      discount = cart_item.product[:discount] || 0
      current_price = current_price price, discount
      current_price * cart_item.quantity
    end
  end

  def total_amount total_price
    total_price + Settings.default.order.delivery_fee
  end

  def order_status_data
    {
      "canceled" => {label: t("view.order_lookup.status_canceled"),
                     css_class: "order-status-canceled", icon: "x-circle"},
      "pending" => {label: t("view.order_lookup.status_pending"),
                    css_class: "order-status-pending", icon: "hourglass-split"},
      "picking" => {label: t("view.order_lookup.status_confirmed"),
                    css_class: "order-status-picking", icon: "box-seam"},
      "shipping" => {label: t("view.order_lookup.status_shipping"),
                     css_class: "order-status-shipping", icon: "truck"},
      "delivered" => {label: t("view.order_lookup.status_delivered"),
                      css_class: "order-status-delivered", icon: "check-circle"}
    }
  end

  def order_status_tag order
    status_info = order_status_data[order.status]
    return unless status_info

    content_tag(:div, status_info[:label], class: status_info[:css_class])
  end
end
