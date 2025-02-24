class User < ApplicationRecord
  has_many :user_addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :cart_products, through: :cart_items, source: :product
  has_many :user_favorites, dependent: :destroy
  has_many :favorite_products, through: :user_favorites, source: :product
  has_many :product_comments, dependent: :destroy

  USER_PARAMS = [:full_name, :user_name, :email, :telephone, :password,
:password_confirmation].freeze

  before_save :downcase_email
  attr_accessor :remember_token

  enum status: {active: 0, in_active: 1, banned: 2}

  validates :full_name,
            presence: true,
            length: {maximum: Settings.default.user.validate
                                      .full_name.maxLength}

  validates :user_name,
            presence: true,
            uniqueness: {case_sensitive: false},
            length: {maximum: Settings.default.user.validate
                                      .user_name.maxLength}

  validates :email,
            presence: true,
            uniqueness: {case_sensitive: false},
            length: {maximum: Settings.default.user.validate
                                      .email.maxLength},
            format: {with: Regexp.new(
              Settings.default.user.validate.email.format, Regexp::IGNORECASE
            )},
            allow_nil: true

  validates :telephone,
            presence: true,
            format: {with: Regexp.new(
              Settings.default.user.validate
                              .telephone.format, Regexp::IGNORECASE
            )},
            allow_nil: true

  validates :password,
            presence: true,
            length: {minimum: Settings.default.user.validate
                                      .password.minLength},
            allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column(:remember_digest, nil)
  end

  def cart_products_quantity
    cart_items.includes(:product)
  end

  def default_address
    user_addresses
      .includes(:province, :district, :ward)
      .find_by(address_default: true)
  end

  def orders_by_status status_number
    return orders if status_number.blank?

    status_text = Order.statuses.key(status_number.to_i)
    return Order.none if status_text.nil?

    orders.where(status: status_text)
  end

  private

  def downcase_email
    email.downcase!
  end
end
