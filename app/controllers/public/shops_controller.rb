class Public::ShopsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[index show]

  FILTER_OPTIONS = {
    papper_tobacco_allowed: "紙タバコ 可",
    heated_tobacco_allowed: "電子タバコ 可",
    wifi_available: "Wi-Fi あり",
    power_available: "電源 あり"
  }.freeze

  def index
    @areas = Shop::AREAS
    @filter_options = FILTER_OPTIONS
    @available_tags = Tag.alphabetical
    # presence_in: 許可リスト外の値は nil に変換（不正な area パラメータを無視）
    @selected_area = params[:area].presence_in(@areas)
    @selected_filters = selected_filters
    @selected_tag_ids = selected_tag_ids
    @total_shops_count = Shop.count
    @shops = paginate_collection(filtered_shops)
    # ページ内の shop に絞って bookmarks を検索し N+1 を防止
    # ログイン済みのときだけ DB アクセスし、未ログインは空 Set を返す
    # to_set により後続の O(1) include? チェックができる
    @bookmarked_shop_ids = authenticated_user? ? current_user.bookmarks.where(shop_id: @shops.map(&:id)).pluck(:shop_id).to_set : Set.new
  end

  def show
    # includes(:tags) と includes(:bookmarked_by_users) で
    # 投稿者一覧・タグ表示時の N+1 を防止
    @shop = Shop.includes(:tags, :bookmarked_by_users).find(params[:id])
    # includes(:user) で最新投稿表示時のユーザー N+1 を防止
    @latest_reports = @shop.reports.includes(:user)
      .order(visited_on: :desc, created_at: :desc, id: :desc)
      .limit(3)
    # bookmarked_by_users は includes 済みなので追加 DB アクセスなし
    @bookmarked_users = @shop.bookmarked_by_users
  end

  private

  def filtered_shops
    # including_tags スコープで tags を一括 includes（一覧でのタグ表示 N+1 対策）
    # recent_first スコープで最終投稿日 → 更新日 → id の順にソート
    shops = Shop.including_tags.recent_first
    shops = shops.by_area(@selected_area) if @selected_area.present?
    # チェックボックスが ON の場合のみ WHERE を追加（チェーン方式で条件を動的に積み上げる）
    shops = shops.where(papper_tobacco_status: :allowed) if @selected_filters.key?("papper_tobacco_allowed")
    shops = shops.where(heated_tobacco_status: :allowed) if @selected_filters.key?("heated_tobacco_allowed")
    shops = shops.where(wifi_available: true) if @selected_filters.key?("wifi_available")
    shops = shops.where(power_available: true) if @selected_filters.key?("power_available")
    # タグ絞り込み: joins で中間テーブルを結合して WHERE を適用
    # 複数タグ選択時に同じ shop が重複しないよう distinct を付ける
    shops = shops.joins(:tags).where(tags: { id: @selected_tag_ids }).distinct if @selected_tag_ids.any?
    shops
  end

  def selected_filters
    # permit で許可リスト外のキーを除外してからスライス・Hash 化
    # value == "1" の条件で実際にチェックが入っている項目のみに絞る
    params.fetch(:filters, {}).permit(*FILTER_OPTIONS.keys, tag_ids: [])
      .slice(*FILTER_OPTIONS.keys)
      .to_h
      .select { |_, value| value == "1" }
  end

  def selected_tag_ids
    # permit で配列パラメータを許可し、空白・重複を除去して Integer に変換
    params.fetch(:filters, {}).permit(tag_ids: [])[:tag_ids]
      .to_a
      .reject(&:blank?)
      .map(&:to_i)
      .uniq
  end
end
