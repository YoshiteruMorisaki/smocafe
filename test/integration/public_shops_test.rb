require "test_helper"

class PublicShopsTest < ActionDispatch::IntegrationTest
  def create_public_pagination_shops(count:, area: "渋谷")
    count.times do |index|
      Shop.create!(
        name: "#{area}ページネーション#{index}",
        area: area,
        address: "東京都#{area}区#{index}-#{index}-#{index}",
        business_hours: "08:00-21:00",
        closed_days: "なし",
        heated_tobacco_status: :allowed,
        papper_tobacco_status: :allowed,
        wifi_available: true,
        power_available: true,
        description: "公開側ページネーション確認用の店舗#{index}",
        last_reported_at: Time.zone.parse("2026-05-01 09:00") + index.minutes
      )
    end
  end

  test "guest can browse shops index and detail" do
    get shops_path
    assert_response :success
    assert_match shops(:shibuya_lounge).name, response.body
    assert_match tags(:wifi).name, response.body
    assert_select "section.shop-index-mobile-tools.d-lg-none"
    assert_select "button[data-bs-target='#shopMobileFilters']", text: /フィルタを開く/
    assert_select "#shopMobileFilters.d-lg-none", text: /条件を選ぶ/
    assert_select "aside.shop-index-sidebar.d-none.d-lg-block"
    assert_select "section.shop-area-filter.d-none.d-lg-block"

    get shop_path(shops(:shibuya_lounge))
    assert_response :success
    assert_match "電子タバコ", response.body
    assert_match "可", response.body
    assert_match tags(:power).name, response.body
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

  test "guest can filter shops by tag ids" do
    get shops_path(filters: { tag_ids: [tags(:quiet).id.to_s] })

    assert_response :success
    assert_match shops(:shinjuku_smoke).name, response.body
    assert_no_match shops(:shibuya_lounge).name, response.body
    assert_select "input[name='filters[tag_ids][]'][value='#{tags(:quiet).id}'][checked='checked']"
    assert_match tags(:quiet).name, response.body
  end

  test "guest shops index paginates filtered results" do
    create_public_pagination_shops(count: 15)

    get shops_path(area: "渋谷")

    assert_response :success
    assert_select ".shop-index-header__count", text: /表示店舗数:\s*12\s*\/\s*全店舗数:\s*17/
    assert_match "渋谷ページネーション14", response.body
    assert_no_match "渋谷ページネーション2", response.body
    assert_select "nav[aria-label='ページネーション']"

    get shops_path(area: "渋谷", page: 2)

    assert_response :success
    assert_match "渋谷ページネーション2", response.body
    assert_match shops(:shibuya_lounge).name, response.body
  end
end
