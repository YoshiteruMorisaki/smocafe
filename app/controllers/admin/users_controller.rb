class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:toggle_active]

  def toggle_active
    @user.update!(is_active: !@user.is_active)
    redirect_back fallback_location: admin_reports_path,
                  notice: "#{@user.name} を#{@user.is_active ? '有効' : '無効'}にしました。"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
