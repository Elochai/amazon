class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :save_url
  before_filter do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    if customer_signed_in?
      redirect_to '/', alert: t(:access_denied)
    else
      redirect_to '/customers/sign_in', alert: t(:sign_up_first)
    end
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_customer)
  end

  def current_order
    if cookies[:current_order]  
      if Order.where(id: cookies[:current_order]).any?
        Order.find(cookies[:current_order])
      end
    end
  end

  def if_no_current_order?
    if cookies[:current_order].nil? 
      redirect_to root_path, alert: t(:select_books_to_buy)
    else
      if Order.where(id: cookies[:current_order]).empty?
        redirect_to root_path, alert: t(:select_books_to_buy)
      end
    end
  end

  def after_sign_in_path_for(resource)
    session.delete(:return_to) || super
  end

  def after_sign_up_path_for(resource)
    session.delete(:return_to) || super
  end

  def save_url
    case request.fullpath
    when /\/addresses$/
      request.fullpath << "/new"
    when /\/credit_cards$/
      request.fullpath << "/new"
    when /add_wish/
      request.fullpath.slice!(/\/add_wish/)
    when /remove_wish/
      request.fullpath.slice!(/\/remove_wish/)
    end
    session[:return_to] = request.fullpath unless request.fullpath =~ /\/customer/
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:firstname, :lastname, :password, :password_confirmation, :current_password) 
    }
    devise_parameter_sanitizer.for(:sign_up) { |u| 
      u.permit(:firstname, :lastname, :password, :password_confirmation, :email) 
    }
  end
end
