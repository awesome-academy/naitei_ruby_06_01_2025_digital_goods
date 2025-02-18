module CartsHelper
  def current_price price, discount
    price * (1 - discount.to_f / 100)
  end
end
