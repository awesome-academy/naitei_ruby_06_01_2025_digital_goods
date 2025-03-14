class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product_id, :order_id, :created_at, :updated_at

  belongs_to :product
end
