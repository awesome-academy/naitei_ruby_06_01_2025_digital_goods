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

  private

  def downcase_email
    email.downcase!
  end
end
