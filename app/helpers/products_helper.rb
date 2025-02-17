module ProductsHelper
  def benefits_list
    [
      t("view.product_detail.benefits.smember_offer"),
      t("view.product_detail.benefits.hsbc_cashback"),
      t("view.product_detail.benefits.vnpay_discount"),
      t("view.product_detail.benefits.acb_credit_discount"),
      t("view.product_detail.benefits.home_credit_discount"),
      t("view.product_detail.benefits.kredivo_discount"),
      t("view.product_detail.benefits.momo_discount"),
      t("view.product_detail.benefits.shopeepay_discount"),
      t("view.product_detail.benefits.b2b_contact")
    ]
  end

  def product_details product
    product_detail = product.product_detail
    [
      {icon: "phone", text: product_detail[:device_condition]},
      {icon: "calendar2-week", text: product_detail[:warranty]},
      {icon: "usb-symbol", text: product_detail[:accessories]},
      {icon: "cash-coin", text: product_detail[:vat]}
    ]
  end

  def installment_price price
    installment = price * Settings.default.product.installment / 100
    number_with_delimiter(installment.to_i)
  end
end
