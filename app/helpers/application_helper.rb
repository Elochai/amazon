module ApplicationHelper
  def current_order
    if cookies[:current_order]
      Order.find(cookies[:current_order]) if Order.where(id: cookies[:current_order]).any?
    end
  end
end
