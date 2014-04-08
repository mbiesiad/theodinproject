class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    if User.find_by_email(request.env["omniauth.auth"]["info"]["email"])
      user.provider = request.env["omniauth.auth"]["provider"]
      user.uid = request.env["omniauth.auth"]["uid"]
      sign_in_and_redirect user
    elsif user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      user.attributes
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :github, :all

  def failure
    flash[:alert] = 'Authentication failed.'
    redirect_to root_path
  end
end
