require "test_helper"

class ShopTest < ActiveSupport::TestCase
  test "enum values can be translated into japanese" do
    shop = shops(:shibuya_lounge)

    assert_equal "可", shop.heated_tobacco_status_i18n
    assert_equal "不可", shop.papper_tobacco_status_i18n
  end

  test "display_image falls back to default image when no image is attached" do
    shop = shops(:shibuya_lounge)

    assert_equal "/no_image.jpg", shop.display_image
  end

  test "area must be one of the fixed choices" do
    shop = shops(:shibuya_lounge)
    shop.area = "池袋"

    assert_not shop.valid?
    assert_includes shop.errors[:area], "は一覧にありません"
  end
end
