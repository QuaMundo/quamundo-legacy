# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # skip_verify_authorized
  rescue_from ActionPolicy::Unauthorized do |ex|
    # FIXME: Manage err msgs
    flash[:alert] = t('.only_admin_registration')
    redirect_to root_path
  end

  before_action -> { authorize! current_user, with: RegistrationPolicy }

  protected
  # Redirect to dashboard after registration
  # (https://github.com/plataformatec/devise/wiki/How-To:-redirect-to-a-specific-page-on-successful-sign_in,-sign_out,-and-or-sign_up)
  def after_sign_up_path_for(resource)
    root_path
  end

  # Allow newly added param (nick)
  # (https://stackoverflow.com/questions/44590059/add-new-fields-to-devise-model-rails-5)
  def sign_up_params
    params.require(:user).permit(:email, :nick, :password,
                                 :password_confirmation)
  end

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
