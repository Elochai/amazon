class Ability
  include CanCan::Ability

  def initialize(customer)
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
        can [:add_wish, :remove_wish, :author_filter, :category_filter, :wishers, :top_rated], Book
        can [:new, :update_with_coupon, :remove_coupon, :confirm, :place, :delivery, :add_delivery, :edit_delivery, :destroy], Order
        can :manage, OrderItem
        can :manage, [CreditCard, Customer, Address]
        can :read, :all
        can [:new, :create], Rating
      end
    else
      can :read, Book
      can :read, Category
      can :read, Author
      can [:top_rated], Book
      can [:author_filter, :category_filter, :wishers], Book
      can :manage, OrderItem
      can :manage, ShipAddress
      can :manage, BillAddress
      can :manage, CreditCard
      can [:new, :update_with_coupon, :remove_coupon, :confirm, :delivery, :add_delivery, :edit_delivery, :destroy], Order
    end
  end
end
