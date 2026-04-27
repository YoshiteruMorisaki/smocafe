class Public::BookmarksController < Public::ApplicationController
  before_action :set_shop, only: [ :create, :destroy ]

  def index
    # includes でN+1を防止（shop情報を一括取得）
    @bookmarks = current_user.bookmarks.includes(:shop).order(created_at: :desc)
    @shops = @bookmarks.map(&:shop)
  end

  def create
    @bookmark = current_user.bookmarks.build(shop: @shop)
    @bookmark.save
    # Turbo Stream レスポンスを返す（ページ全体リロードなしでボタンを差し替え）
    # create.turbo_stream.erb が自動的に使われる
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find_by!(shop: @shop)
    @bookmark.destroy
    # Turbo Stream レスポンスを返す（ページ全体リロードなしでボタンを差し替え）
    # destroy.turbo_stream.erb が自動的に使われる
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
