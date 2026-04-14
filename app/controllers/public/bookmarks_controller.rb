class Public::BookmarksController < Public::ApplicationController
  before_action :set_shop, only: %i[create destroy]

  def index
    @shops = paginate_collection(
      current_user.bookmarked_shops
        .includes(:tags, image_attachment: :blob)
        .recent_first
    )
  end

  def create
    current_user.bookmarks.find_or_create_by(shop: @shop)
    redirect_back fallback_location: shop_path(@shop), notice: "お気に入りに追加しました。"
  end

  def destroy
    current_user.bookmarks.find_by(shop: @shop)&.destroy
    redirect_back fallback_location: shop_path(@shop), notice: "お気に入りを解除しました。"
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
