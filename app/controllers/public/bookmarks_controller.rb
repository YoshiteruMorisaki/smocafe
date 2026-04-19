class Public::BookmarksController < Public::ApplicationController
  before_action :set_shop, only: [:create, :destroy]

  def index
    @bookmarks = current_user.bookmarks.includes(:shop).order(created_at: :desc)
    @shops = @bookmarks.map(&:shop)
  end

  def create
    @bookmark = current_user.bookmarks.build(shop: @shop)
    @bookmark.save
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find_by!(shop: @shop)
    @bookmark.destroy
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
