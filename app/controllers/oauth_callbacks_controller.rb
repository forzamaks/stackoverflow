class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth(:github)
  end

  def vkontakte
    oauth(:vkontakte)
  end 

  def oauth(type)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: type) if is_navigational_format?
    elsif @user
      session[:provider] = auth[:provider]
      session[:uid] = auth[:uid]
      redirect_to new_user_confirmation_path, notice: 'Please provide your email'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end