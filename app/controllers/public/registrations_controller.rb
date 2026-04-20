class Public::RegistrationsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to users_my_page_path, notice: "会員登録が完了しました。"
    else
      flash.now[:alert] = "会員登録に失敗しました。入力内容をご確認ください。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :profile_image)
  end
end
