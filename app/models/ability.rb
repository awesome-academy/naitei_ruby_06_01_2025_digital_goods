class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    define_guest_permissions

    return unless user.persisted?

    define_user_permissions(user)

    return unless user.admin?

    can :manage, :all
  end

  private

  def define_guest_permissions
    can :read, Product
    can :create, User
    can :read, ProductComment
    can :find_order, Order
  end

  def define_user_permissions user
    define_user_management_permissions(user)
    define_product_comment_permissions(user)
    define_order_permissions(user)
    define_cart_item_permissions(user)
  end

  def define_user_management_permissions user
    can :manage, User, id: user.id
    can :manage, CartItem, user_id: user.id
    can :manage, UserAddress, user_id: user.id
    can :manage, UserFavorite, user_id: user.id
  end

  def define_product_comment_permissions user
    can :create, ProductComment
    can :update, ProductComment, user_id: user.id
    can :destroy, ProductComment, user_id: user.id
  end

  def define_order_permissions user
    can :create, Order
    can :read, Order, user_id: user.id
    can :history_order, Order, user_id: user.id
    can :update, Order, user_id: user.id
    can :create, OrderItem, user_id: user.id
  end

  def define_cart_item_permissions user
    can :manage, CartItem, user_id: user.id
    can :update_checked, CartItem, user_id: user.id
  end
end
