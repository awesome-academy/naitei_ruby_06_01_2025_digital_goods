module Admin::ProductsHelper
  def admin_page_menu
    [
      {path: "#", icon: "house", text: t("view.user.menu.home"),
       class: "menu__item--home"},
      {
        path: admin_products_path,
        icon: "box-seam",
        text: t("view.user.menu.product"),
        class: "menu__item--products"
      },
      {
        path: admin_orders_path,
        icon: "bag-check",
        text: t("view.user.menu.order"),
        class: "menu__item--orders"
      },
      {path: "#", icon: "people", text: t("view.user.menu.admin_list"),
       class: "menu__item--admins"},
      {path: "#", icon: "people", text: t("view.user.menu.user_list"),
       class: "menu__item--users"},
      {path: "#", icon: "person", text: t("view.user.menu.account"),
       class: "menu__item--account"},
      {path: "#", icon: "box-arrow-right", text: t("view.user.menu.logout"),
       class: "menu__item--logout", method: :delete}
    ]
  end

  def categories_filter
    [
      {target: "filter-container-1",
       text: @category_lv1_name || t("view.admin.product.filter_by"),
       categories: @categories_lv1},
      {target: "filter-container-2",
       text: @category_lv2_name || t("view.admin.product.filter_by"),
       categories: @categories_lv2},
      {target: "filter-container-3",
       text: @category_lv3_name || t("view.admin.product.filter_by"),
       categories: @categories_lv3}
    ]
  end

  def product_form_steps
    [
      {key: :product_info, icon: "box-seam",
       label: t("view.admin.product.product_info")},
      {key: :product_detail, icon: "card-text",
       label: t("view.admin.product.product_detail")},
      {key: :attributes, icon: "device-ssd",
       label: t("view.admin.product.attributes")},
      {key: :category, icon: "card-checklist",
       label: t("view.admin.product.category")}
    ]
  end

  def product_basic_info_fields
    [
      {name: :product_title, type: :text_field},
      {name: :description, type: :text_area},
      {name: :price, type: :number_field},
      {name: :discount, type: :number_field},
      {name: :color, type: :text_field},
      {name: :stock_quantity, type: :number_field}
    ]
  end

  def product_detail_fields
    [
      {name: :device_condition, type: :text_field},
      {name: :warranty, type: :text_field},
      {name: :accessories, type: :text_area},
      {name: :vat, type: :text_field}
    ]
  end
end
