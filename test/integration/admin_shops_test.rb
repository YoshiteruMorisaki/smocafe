require "test_helper"

class AdminShopsTest < ActionDispatch::IntegrationTest
  setup do
    post admin_sign_in_path, params: {
      email_address: admins(:primary).email_address,
      password: "password"
    }
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
          last_reported_at: "2026-04-03T09:00"
        }
      }
    end

    shop = Shop.order(:id).last
    assert_redirected_to admin_shops_path

    patch admin_shop_path(shop), params: {
      shop: {
        area: "上野",
        papper_tobacco_status: "allowed"
      }
    }

    assert_redirected_to admin_shops_path
    assert_equal "上野", shop.reload.area
    assert_equal "allowed", shop.papper_tobacco_status

    assert_difference("Shop.count", -1) do
      delete admin_shop_path(shop)
    end

    assert_redirected_to admin_shops_path
  end

  test "admin shops page requires authentication" do
    delete admin_sign_out_path

    get admin_shops_path
    assert_redirected_to admin_sign_in_path
  end
end
