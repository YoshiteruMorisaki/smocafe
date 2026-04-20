class Public::SessionsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    redirect_to users_my_page_path, notice: "すでにログインしています。" if authenticated_user?
  end

  def create
    # strip.downcase は User モデルの normalizes でも行われるが、
    # ここでは find_by 前に正規化して大文字小文字の違いによる検索ミスを防ぐ
    user = User.find_by(email_address: params[:email_address].to_s.strip.downcase)

    # user& で nil チェック。authenticate は has_secure_password が提供するメソッドで
    # BCrypt でハッシュ化されたパスワードと照合する
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
