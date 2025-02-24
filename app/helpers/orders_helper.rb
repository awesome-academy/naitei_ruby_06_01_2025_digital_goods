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

  def menu_order_items
    [
      {path: root_path, icon: "house", text: t("view.user.menu.home"),
       class: "menu__item--home"},
      {path: orders_path, icon: "clock-history",
       text: t("view.user.menu.purchase_history"),
       class: "menu__item--history"},
      {path: "#", icon: "shield-check",
       text: t("view.user.menu.warranty_lookup"),
       class: "menu__item--warranty"},
      {path: "#", icon: "gift", text: t("view.user.menu.promotions"),
       class: "menu__item--promotion"},
      {path: "#", icon: "mortarboard",
       text: t("view.user.menu.s_edu_program"), class: "menu__item--education"},
      {path: "#", icon: "award", text: t("view.user.menu.membership_rank"),
       class: "menu__item--rank"},
      {path: "#", icon: "person", text: t("view.user.menu.account"),
       class: "menu__item--account"},
      {path: "#", icon: "people", text: t("view.user.menu.linked_accounts"),
       class: "menu__item--link"},
      {path: "#", icon: "headset", text: t("view.user.menu.support"),
       class: "menu__item--support"},
      {path: "#", icon: "heart", text: t("view.user.menu.feedback"),
       class: "menu__item--feedback"},
      {path: "#", icon: "box-arrow-right", text: t("view.user.menu.logout"),
       class: "menu__item--logout", method: :delete}
    ]
  end

  def format_datetime datetime
    datetime.strftime("%d/%m/%Y %H:%M") if datetime.present?
  end
end
