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

  test "guest can filter shops by area" do
    get shops_path(area: "渋谷")

    assert_response :success
    assert_match "渋谷エリアの店舗一覧", response.body
    assert_match shops(:shibuya_lounge).name, response.body
    assert_no_match shops(:shinjuku_smoke).name, response.body
  end
end
