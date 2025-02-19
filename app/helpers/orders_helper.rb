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
end
