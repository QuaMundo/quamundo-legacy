# frozen_string_literal: true

class UsersController < ApplicationController
  rescue_from ActionPolicy::Unauthorized do |_ex|
    flash[:alert] = t('.not_allowed')
    redirect_to root_path
  end

  def index
    @users = User.all
    authorize! @users
  end

  def new
    @new_user = User.new
    authorize! @new_user
  end

  def create
    @new_user = User.new(user_params)
    authorize! @new_user

    respond_to do |format|
      if @new_user.save
        format.html do
          redirect_to(users_path,
                      notice: t('.created', user: @new_user.nick))
        end
      else
        format.html do
          flash[:alert] = t('.create_failed', user: @new_user.nick)
          render :new
        end
      end
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:nick, :email, :password, :password_confiramtion)
  end
end
