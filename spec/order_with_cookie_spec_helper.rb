def create_order!
  @order = FactoryGirl.create :order
  cookies[:current_order] = @order.id
end