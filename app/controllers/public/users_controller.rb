class Public::UsersController < Public::ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to users_my_page_path, notice: "会員情報を更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。入力内容をご確認ください。"
      render :edit, status: :unprocessable_entity
    end
  end

  def unsubscribe
    @user = current_user
  end

  def withdraw
    if current_user.update(is_active: false)
      terminate_session
      redirect_to root_path, notice: "退会処理が完了しました。"
    else
      redirect_to users_unsubscribe_path, alert: "退会処理に失敗しました。"
    end
  end

  private

  def user_params
    permitted = params.require(:user).permit(:name, :email_address, :password, :password_confirmation)

    if permitted[:password].blank?
      permitted.delete(:password)
      permitted.delete(:password_confirmation)
    end

    permitted
  end
end
