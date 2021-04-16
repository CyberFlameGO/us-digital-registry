class Admin::AdminController < ApplicationController
  include PublicActivity::StoreController
  layout "admin"

  before_action :authenticate_user! unless Rails.env.development? || ENV['IMPERSONATE_ADMIN'].present?
  # before_filter :admin_two_factor, except: [:about, :impersonate, :dashboard]

  before_action :banned_user?, except: [:about, :impersonate, :dashboard]
  before_action :headers
  helper_method :current_user

  def impersonate
    session[:user_id] = params[:user_id]
    @current_user = User.find(params[:user_id])
    redirect_to admin_dashboards_path, notice: "Now impersonating: #{User.find(params[:user_id]).email} with role: #{User.find(params[:user_id]).role.humanize}"
  end

  def user_has_agency
    if current_user.agency
      return true
    else
      redirect_to admin_user_path(current_user.id), notice: "You do not currently have an Agency assigned to user user, please update your user profile to manage accounts"
    end
  end

  def headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
  end

  def current_user
    if Rails.env.development? || ENV['IMPERSONATE_ADMIN'].present?
      if session[:user_id] && User.where(id: session[:user_id]).count > 0
        @current_user ||= User.find(session[:user_id])
      else
         @current_user ||= User.where(role: 2).first
      end
    else
      @current_user ||= warden.authenticate(scope: :user)
    end
  end

  def admin_two_factor
    # THIS has been disabled due to the move to login.gov.  Will totally remove logic after a test build
    # if Rails.env.development? || ENV['IMPERSONATE_ADMIN'].present?
    #   #do nothing because its dev!
    # else
    #   if !current_user.user.include?("TwoFactor")
    #     redirect_to root_path, status: 302, notice: "You must login with Two Factor Authentication to utilize administrative functionality."
    #   end
    # end
  end

  def banned_user?
    if current_user.banned?
      redirect_to root_path, status: 302, notice: "You have been banned from the system you may want to email an admin directly if you believe this to be in error."
    end
  end

  def require_admin
    if !current_user.admin?
      redirect_to admin_dashboards_path, notice: "This page requires administrative privileges.  You have been redirected."
    end
  end

  def require_admin_or_owner
    if !current_user.admin? && current_user.id != @user.id
      redirect_to admin_dashboards_path, notice: "You do not have the appopriate permissions to this item, you have been redirected."
    end
  end

end
