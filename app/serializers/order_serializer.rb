class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total_price, :delivery_fee, :payment_status, :status,
             :notice, :reason_cancel, :confirmed_at, :shipped_at, :cancel_at,
             :created_at, :updated_at, :user_id, :user_address_id, :full_address

  has_many :order_items

  def full_address
    [
      object.user_address[:location],
      object.user_address.ward[:name],
      object.user_address.district[:name],
      object.user_address.province[:name]
    ].compact.join(", ")
  end
end
