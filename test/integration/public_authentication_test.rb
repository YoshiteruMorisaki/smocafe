require "test_helper"

class PublicAuthenticationTest < ActionDispatch::IntegrationTest
  test "user can sign up and see my page" do
    get users_sign_up_path
    assert_response :success

    assert_difference("User.count", 1) do
      post users_path, params: {
        user: {
          name: "New User",
          email_address: "new-user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to users_my_page_path
    follow_redirect!
    assert_response :success
    assert_match "New User", response.body
  end

  test "user can sign in and sign out" do
    post users_sign_in_path, params: {
      email_address: users(:active_user).email_address,
      password: "password"
    }

    assert_redirected_to users_my_page_path

    delete users_sign_out_path
    assert_redirected_to root_path
  end

  test "user can update profile without changing password" do
    post users_sign_in_path, params: {
      email_address: users(:active_user).email_address,
      password: "password"
    }

    patch users_path, params: {
      user: {
        name: "Updated User",
        email_address: users(:active_user).email_address,
        password: "",
        password_confirmation: ""
      }
    }

    assert_redirected_to users_my_page_path
    follow_redirect!
    assert_response :success
    assert_match "会員情報を更新しました。", response.body

    users(:active_user).reload
    assert_equal "Updated User", users(:active_user).name
    assert users(:active_user).authenticate("password")
  end
end
