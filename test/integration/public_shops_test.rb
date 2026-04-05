require "test_helper"

class PublicShopsTest < ActionDispatch::IntegrationTest
  test "guest can browse shops index and detail" do
    get shops_path
    assert_response :success
    assert_match shops(:shibuya_lounge).name, response.body

    get shop_path(shops(:shibuya_lounge))
    assert_response :success
    assert_match "電子タバコ", response.body
    assert_match "可", response.body
  end
end
