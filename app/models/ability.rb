class Ability 
  include CanCan::Ability

  def initialize(customer, *order)
    if !order.first.nil?
      current_order = order.first.id
    else
      current_order = order.first
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    if customer
      if customer.admin == true
        can :manage, :all
        can :access, :rails_admin
        can :dashboard
        can :state, Order
      else
        can [:add_wish, :remove_wish, :wishers, :top_rated], Book
        can [:new, :update_with_coupon, :remove_coupon, :confirm, :place, :delivery, :add_delivery, :edit_delivery, :checkout, :next_step], Order
        can [:index, :clear_cart, :create], OrderItem
        can [:edit, :update, :destroy], OrderItem, :order_id => current_order
        can :manage, Customer
        can [:new, :create], CreditCard
        can [:update, :edit], CreditCard, :order_id => current_order
        can :manage, [Address], type: 'CustomerBillAddress', :customer_id => customer.id 
        can :manage, [Address], type: 'CustomerShipAddress', :customer_id => customer.id 
        can :manage, [Address], type: 'BillAddress', :order_id => current_order
        can :manage, [Address], type: 'ShipAddress', :order_id => current_order
        can :read, [Book, Rating, Category, Author] 
        can :read, Order, :customer_id => customer.id
        can [:new, :create], Rating
      end
    else
      can :read, [Book, Category, Author]
      can [:top_rated, :wishers], Book
      can [:index, :clear_cart, :create], OrderItem
      can [:edit, :update, :destroy], OrderItem, :order_id => current_order
      can :manage, [Address], type: 'BillAddress', :order_id => current_order
      can :manage, [Address], type: 'ShipAddress', :order_id => current_order
      can [:new, :create], CreditCard
      can [:update, :edit], CreditCard, :order_id => current_order
      can [:checkout, :new, :update_with_coupon, :remove_coupon, :confirm, :delivery, :add_delivery, :edit_delivery, :next_step], Order
    end
  end
end
