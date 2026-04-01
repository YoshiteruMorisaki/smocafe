class Admin::SessionsController < Admin::ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    redirect_to admin_root_path, notice: "すでに管理者としてログインしています。" if authenticated_admin?
  end

  def create
    admin = Admin.find_by(email_address: params[:email_address].to_s.strip.downcase)

    if admin&.authenticate(params[:password])
      start_new_session_for(admin)
      redirect_to(after_authentication_url, notice: "管理者ログインに成功しました。")
    else
      @email_address = params[:email_address]
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to admin_sign_in_path, notice: "管理者ログアウトしました。"
  end
end
