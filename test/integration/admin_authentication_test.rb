require "test_helper"

class AdminAuthenticationTest < ActionDispatch::IntegrationTest
  test "admin root redirects to sign in when unauthenticated" do
    get admin_root_path
    assert_redirected_to admin_sign_in_path
  end

  test "admin can sign in" do
    post admin_sign_in_path, params: {
      email_address: admins(:primary).email_address,
      password: "password"
    }

    assert_redirected_to admin_root_path
    follow_redirect!
    assert_response :success
    # ログイン後はダッシュボードが表示される（メールアドレス表示は廃止済み）
    assert_match "管理ダッシュボード", response.body
  end
end
