module StaticPagesHelper
  def menu_items
    [
      {icon: "phone", label: t("view.home.featured_phone"), link: "#"},
      {icon: "laptop", label: t("view.home.laptop"), link: "#"},
      {icon: "earbuds", label: t("view.home.audio"), link: "#"},
      {icon: "smartwatch", label: t("view.home.smartwatch"), link: "#"},
      {icon: "house-check", label: t("view.home.home_appliance"), link: "#"},
      {icon: "pc-display-horizontal", label: t("view.home.monitor"), link: "#"},
      {icon: "tv", label: t("view.home.tv"), link: "#"},
      {icon: "camera", label: t("view.home.camera"), link: "#"},
      {icon: "usb-plug", label: t("view.home.accessory"), link: "#"},
      {icon: "printer", label: t("view.home.printer"), link: "#"},
      {icon: "cpu", label: t("view.home.computer_component"), link: "#"},
      {icon: "file-text", label: t("view.home.tech_news"), link: "#"}
    ]
  end

  def discounted_price price, discount
    discounted = price * (1 - discount.to_f / 100)
    number_with_delimiter(discounted.to_i)
  end

  def product_price price
    number_with_delimiter(price.to_i)
  end
end
