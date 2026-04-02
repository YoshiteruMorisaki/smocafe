class Public::SessionsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    redirect_to users_my_page_path, notice: "すでにログインしています。" if authenticated_user?
  end

  def create
    user = User.find_by(email_address: params[:email_address].to_s.strip.downcase)

    if user&.authenticate(params[:password])
      if user.is_active?
        start_new_session_for(user)
        redirect_to(after_authentication_url, notice: "ログインしました。")
      else
        @email_address = params[:email_address]
        flash.now[:alert] = "退会済みのためログインできません。"
        render :new, status: :unprocessable_entity
      end
    else
      @email_address = params[:email_address]
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
