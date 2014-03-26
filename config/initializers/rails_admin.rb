RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  config.current_user_method(&:current_customer)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.model 'Author' do
    object_label_method do
      :author_field
    end
  end

  config.model 'Category' do
    object_label_method do
      :category_field
    end
  end

  config.model 'Coupon' do
    object_label_method do
      :coupon_field
    end
  end

  config.model 'Delivery' do
    object_label_method do
      :delivery_field
    end
  end

  config.model 'Country' do
    object_label_method do
      :country_field
    end
  end

  config.model 'BillAddress' do
    object_label_method do
      :addr_field
    end
  end

  config.model 'ShipAddress' do
    object_label_method do
      :addr_field
    end
  end

  config.model 'OrderItem' do
    object_label_method do
      :order_item_field
    end
  end

  config.model 'Customer' do
    object_label_method do
      :customer_email
    end
  end

  def customer_email
    "#{email}"
  end

  def order_item_field
    "#{book.title}(qty: #{quantity.to_s})"
  end

  def author_field
    "#{full_name}"
  end

  def category_field
    "#{title}"
  end

  def coupon_field
    "Coupon ##{id}(#{name})"
  end

  def delivery_field
    "#{name}"
  end

  def country_field
    "#{name}"
  end

  def addr_field
    "Address ##{id}(#{country.name}, #{city}, #{address})"
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    state
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
