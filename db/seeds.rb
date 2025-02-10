# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

User.destroy_all
Province.destroy_all
District.destroy_all
Ward.destroy_all
UserAddress.destroy_all
Product.destroy_all
ProductDetail.destroy_all
Category.destroy_all
ProductCategory.destroy_all
AttributeGroup.destroy_all
ProductAttribute.destroy_all
UserFavorite.destroy_all
ProductComment.destroy_all
CartItem.destroy_all
Order.destroy_all
OrderItem.destroy_all
OrderJourney.destroy_all

users = []
5.times do
  users << User.create!(
    user_name: Faker::Internet.unique.username,
    full_name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    telephone: Faker::PhoneNumber.phone_number,
    password_digest: 'password',
    admin: false,
    status: ['active', 'inactive', 'banned'].sample
  )
end

provinces = 5.times.map { Province.create!(name: Faker::Address.state) }
districts = provinces.flat_map { |p| 3.times.map { District.create!(name: Faker::Address.city, province: p) } }
wards = districts.flat_map { |d| 3.times.map { Ward.create!(name: Faker::Address.community, district: d) } }

users.each do |user|
  UserAddress.create!(
    user: user,
    province: provinces.sample,
    district: districts.sample,
    ward: wards.sample,
    location: Faker::Address.street_address
  )
end

categories = []
categories << Category.create!(name: "Điện thoại", path: "/1/", level: 1)
categories << Category.create!(name: "Hãng", path: "/1/2", level: 2)
categories << Category.create!(name: "Apple", path: "/1/2/3", level: 3)
categories << Category.create!(name: "Samsung", path: "/1/2/4", level: 3)
categories << Category.create!(name: "Laptop", path: "/2/", level: 1)
categories << Category.create!(name: "Gaming", path: "/2/5", level: 2)
categories << Category.create!(name: "Ultrabook", path: "/2/6", level: 2)
categories << Category.create!(name: "Phụ kiện", path: "/3/", level: 1)
categories << Category.create!(name: "Tai nghe", path: "/3/7", level: 2)
categories << Category.create!(name: "Sạc dự phòng", path: "/3/8", level: 2)
categories << Category.create!(name: "Thiết bị thông minh", path: "/4/", level: 1)
categories << Category.create!(name: "Đèn LED", path: "/4/9", level: 2)
categories << Category.create!(name: "Camera an ninh", path: "/4/10", level: 2)

products = 20.times.map do
  Product.create!(
    product_title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph,
    price: Faker::Commerce.price(range: 500.0..3000.0),
    discount: [0, 5, 10, 15].sample,
    rating: rand(1.0..5.0).round(1),
    color: Faker::Color.color_name,
    stock_quantity: rand(10..100)
  )
end

products.each do |product|
  ProductCategory.create!(product: product, category: categories.sample)
end

products.each do |product|
  ProductDetail.create!(
    product: product,
    device_condition: %w[New Used Refurbished].sample,
    warranty: "#{rand(6..24)} months",
    accessories: Faker::Lorem.words(number: 3).join(", "),
    vat: ["Included", "Not Included"].sample
  )
end

attribute_groups = []
attribute_groups << AttributeGroup.create!(attribute_name: "Màn hình", path: "/1/", level: 1)
attribute_groups << AttributeGroup.create!(attribute_name: "Kích thước", path: "/1/2", level: 2)
attribute_groups << AttributeGroup.create!(attribute_name: "Độ phân giải", path: "/1/3", level: 2)
attribute_groups << AttributeGroup.create!(attribute_name: "Tần số quét", path: "/1/4", level: 2)

attribute_groups << AttributeGroup.create!(attribute_name: "Camera", path: "/2/", level: 1)
attribute_groups << AttributeGroup.create!(attribute_name: "Camera chính", path: "/2/5", level: 2)
attribute_groups << AttributeGroup.create!(attribute_name: "Camera góc rộng", path: "/2/6", level: 2)
attribute_groups << AttributeGroup.create!(attribute_name: "Camera tele", path: "/2/7", level: 2)

attribute_groups << AttributeGroup.create!(attribute_name: "Bộ nhớ", path: "/3/", level: 1)
attribute_groups << AttributeGroup.create!(attribute_name: "RAM", path: "/3/8", level: 2)
attribute_groups << AttributeGroup.create!(attribute_name: "ROM", path: "/3/9", level: 2)
attribute_groups << AttributeGroup.create!(attribute_name: "Hỗ trợ thẻ nhớ", path: "/3/10", level: 2)

attribute_groups << AttributeGroup.create!(attribute_name: "Chip", path: "/4/", level: 1)
attribute_groups << AttributeGroup.create!(attribute_name: "Loại chip", path: "/4/11", level: 2)
attribute_groups << AttributeGroup.create!(attribute_name: "Xung nhịp", path: "/4/12", level: 2)
attribute_groups << AttributeGroup.create!(attribute_name: "Số nhân", path: "/4/13", level: 2)

products.each do |product|
  2.times do
    ProductAttribute.create!(
      product: product,
      attribute_group: attribute_groups.sample,
      value: Faker::Commerce.material
    )
  end
end

users.each do |user|
  UserFavorite.create!(user: user, product: products.sample)
end

users.each do |user|
  ProductComment.create!(
    product: products.sample,
    user: user,
    content: Faker::Lorem.sentence,
    likes: rand(0..100)
  )
end

users.each do |user|
  CartItem.create!(
    user: user,
    product: products.sample,
    quantity: rand(1..5),
  )
end

orders = users.map do |user|
  Order.create!(
    user: user,
    user_address_id: user.user_addresses.sample.id,
    total_price: Faker::Commerce.price(range: 1000.0..5000.0),
    delivery_fee: [0, 20, 50].sample,
    payment_status: [true, false].sample,
    status: %w[pending processing shipped delivered canceled].sample
  )
end

orders.each do |order|
  2.times do
    product = products.sample
    OrderItem.create!(
      order: order,
      product: product,
      quantity: rand(1..3),
    )
  end
end

orders.each do |order|
  OrderJourney.create!(
    order: order,
    location: Faker::Address.street_address,
    province: provinces.sample,
    district: districts.sample,
    ward: wards.sample,
    status: %w[in_transit delivered failed].sample
  )
end
