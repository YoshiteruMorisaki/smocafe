require "test_helper"

class AdminShopsTest < ActionDispatch::IntegrationTest
  setup do
    post admin_sign_in_path, params: {
      email_address: admins(:primary).email_address,
      password: "password"
    }
  end

  def create_admin_pagination_shops(count:)
    count.times do |index|
      Shop.create!(
        name: "管理ページネーション#{index}",
        area: Shop::AREAS[index % Shop::AREAS.size],
        address: "東京都管理区#{index}-#{index}-#{index}",
        business_hours: "09:00-22:00",
        closed_days: "なし",
        heated_tobacco_status: :allowed,
        papper_tobacco_status: :allowed,
        wifi_available: true,
        power_available: true,
        description: "管理側ページネーション確認用の店舗#{index}",
        last_reported_at: Time.zone.parse("2026-05-10 10:00") + index.minutes
      )
    end
  end

  test "admin can create update and destroy shop" do
    assert_difference("Shop.count", 1) do
      post admin_shops_path, params: {
        shop: {
          name: "東京ワークカフェ",
          area: "東京",
          address: "東京都東京エリア3-3-3",
          business_hours: "08:00-21:00",
          closed_days: "なし",
          heated_tobacco_status: "allowed",
          papper_tobacco_status: "disallowed",
          wifi_available: "1",
          power_available: "0",
          description: "作業向けの新規店舗",
          last_reported_at: "2026-04-03T09:00",
          tag_ids: [tags(:wifi).id, tags(:quiet).id]
        }
      }
    end

    shop = Shop.order(:id).last
    assert_redirected_to admin_shops_path
    assert_equal [tags(:wifi).name, tags(:quiet).name], shop.reload.tag_names

    patch admin_shop_path(shop), params: {
      shop: {
        area: "上野",
        papper_tobacco_status: "allowed",
        tag_ids: [tags(:power).id]
      }
    }

    assert_redirected_to admin_shops_path
    assert_equal "上野", shop.reload.area
    assert_equal "allowed", shop.papper_tobacco_status
    assert_equal [tags(:power).name], shop.tag_names

    assert_difference("Shop.count", -1) do
      delete admin_shop_path(shop)
    end

    assert_redirected_to admin_shops_path
  end

  test "admin can navigate from dashboard to shops index and edit" do
    get admin_root_path
    assert_response :success
    assert_select "a[href='#{admin_shops_path}']", text: /一覧を見る/

    get admin_shops_path
    assert_response :success
    assert_select "a[href='#{edit_admin_shop_path(shops(:shibuya_lounge))}']", text: /編集/

    get edit_admin_shop_path(shops(:shibuya_lounge))
    assert_response :success
    assert_match shops(:shibuya_lounge).name, response.body
  end

  test "admin shops page requires authentication" do
    delete admin_sign_out_path

    get admin_shops_path
    assert_redirected_to admin_sign_in_path
  end

  test "admin shops index paginates shop records" do
    create_admin_pagination_shops(count: 15)

    get admin_shops_path

    assert_response :success
    assert_match "管理ページネーション14", response.body
    assert_no_match "管理ページネーション2", response.body
    assert_select "nav[aria-label='ページネーション']"

    get admin_shops_path(page: 2)

    assert_response :success
    assert_match "管理ページネーション2", response.body
    assert_match shops(:shibuya_lounge).name, response.body
  end
end
