module Public::Authentication
  extend ActiveSupport::Concern

  included do
    before_action :resume_session
    before_action :require_authentication
    helper_method :authenticated_user?, :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def current_user
    resume_session
    @current_user ||= Current.user if Current.session
  end

  def authenticated_user?
    resume_session
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
  end

  def request_authentication
    session[:return_to_after_authenticating] = request.url
    redirect_to users_sign_in_path, alert: "ログインしてください。"
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || users_my_page_path
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |auth_session|
      Current.session = auth_session
      cookies.signed.permanent[:session_id] = { value: auth_session.id, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    Current.session&.destroy
    Current.session = nil
    cookies.delete(:session_id)
  end
end
