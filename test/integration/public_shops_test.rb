require "test_helper"

class PublicShopsTest < ActionDispatch::IntegrationTest
  test "guest can browse shops index and detail" do
    get shops_path
    assert_response :success
    assert_match shops(:shibuya_lounge).name, response.body
    assert_select "section.shop-index-mobile-tools.d-lg-none"
    assert_select "button[data-bs-target='#shopMobileFilters']", text: /フィルタを開く/
    assert_select "#shopMobileFilters.d-lg-none", text: /条件を選ぶ/
    assert_select "aside.shop-index-sidebar.d-none.d-lg-block"
    assert_select "section.shop-area-filter.d-none.d-lg-block"

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

  test "guest can filter shops by smoking and facility conditions" do
    get shops_path(filters: { heated_tobacco_allowed: "1", wifi_available: "1" })

    assert_response :success
    assert_match shops(:shibuya_lounge).name, response.body
    assert_no_match shops(:shinjuku_smoke).name, response.body
    assert_match "電子タバコ 可", response.body
    assert_match "Wi-Fi あり", response.body
  end
end
