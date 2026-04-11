require "test_helper"

class AdminTagsTest < ActionDispatch::IntegrationTest
  setup do
    post admin_sign_in_path, params: {
      email_address: admins(:primary).email_address,
      password: "password"
    }
  end

  test "admin can create update and destroy tag" do
    assert_difference("Tag.count", 1) do
      post admin_tags_path, params: {
        tag: {
          name: "深夜営業"
        }
      }
    end

    tag = Tag.order(:id).last
    assert_redirected_to admin_tags_path

    patch admin_tag_path(tag), params: {
      tag: {
        name: "朝営業"
      }
    }

    assert_redirected_to admin_tags_path
    assert_equal "朝営業", tag.reload.name

    assert_difference("Tag.count", -1) do
      delete admin_tag_path(tag)
    end

    assert_redirected_to admin_tags_path
  end

  test "admin can navigate to tags index and edit" do
    get admin_root_path
    assert_response :success
    assert_select "a[href='#{admin_tags_path}']", text: /一覧を見る/

    get admin_tags_path
    assert_response :success
    assert_select "a[href='#{edit_admin_tag_path(tags(:wifi))}']", text: /編集/

    get edit_admin_tag_path(tags(:wifi))
    assert_response :success
    assert_match tags(:wifi).name, response.body
  end

  test "admin tags page requires authentication" do
    delete admin_sign_out_path

    get admin_tags_path
    assert_redirected_to admin_sign_in_path
  end
end
