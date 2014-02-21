class Customers::OmniauthCallbacksController < ApplicationController
  def facebook
    <hh customer=customer> = Customer.find_for_facebook_oauth request.env["omniauth.auth"]
    if <hh customer=customer>.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect <hh customer=customer>, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
  end
end
