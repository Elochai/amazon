class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_want_complete
  before_filter do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to customer_session_path, alert: t(:sign_up_first)
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

  def set_want_complete
    session[:return_to] = request.fullpath unless request.fullpath =~ /\/customer/
  end

  def redirect_to_previous
    session[:return_to] ||= request.referer 
    redirect_to session.delete(:return_to)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:firstname, :lastname, :password, :password_confirmation, :current_password) 
    }
  end
end
