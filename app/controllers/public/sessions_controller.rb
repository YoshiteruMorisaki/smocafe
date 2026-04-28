class Public::SessionsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    session[:return_to_after_authenticating] = safe_return_to_path(params[:return_to]) if params[:return_to].present?
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

  private

  def safe_return_to_path(raw_path)
    # ログイン後の戻り先として使える「同一アプリ内の相対パス」のみ許可する
    parsed = URI.parse(raw_path)

    # 外部URLへの遷移を防ぐ（open redirect 対策）
    return if parsed.scheme.present? || parsed.host.present?
    # 先頭が / のアプリ内パスのみ許可
    return unless parsed.path.start_with?("/")
    # //example.com のようなプロトコル相対URLを拒否
    return if raw_path.start_with?("//")

    # クエリ文字列は維持して復元する
    query = parsed.query.present? ? "?#{parsed.query}" : ""
    "#{parsed.path}#{query}"
  rescue URI::InvalidURIError
    # 不正なURL文字列は戻り先として使わない
    nil
  end
end
