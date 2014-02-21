class Customers::OmniauthCallbacksController < ApplicationController
  def facebook
    @customer = Customer.find_for_facebook_oauth request.env["omniauth.auth"]
    if @customer.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @customer, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end
end
