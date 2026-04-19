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
    @selected_area = params[:area].presence_in(@areas)
    @selected_filters = selected_filters
    @selected_tag_ids = selected_tag_ids
    @total_shops_count = Shop.count
    @shops = paginate_collection(filtered_shops)
    @bookmarked_shop_ids = authenticated_user? ? current_user.bookmarks.where(shop_id: @shops.map(&:id)).pluck(:shop_id).to_set : Set.new
  end

  def show
    @shop = Shop.includes(:tags).find(params[:id])
    @latest_reports = @shop.reports.includes(:user)
      .order(visited_on: :desc, created_at: :desc, id: :desc)
      .limit(3)
  end

  private

  def filtered_shops
    shops = Shop.including_tags.recent_first
    shops = shops.by_area(@selected_area) if @selected_area.present?
    shops = shops.where(papper_tobacco_status: :allowed) if @selected_filters.key?("papper_tobacco_allowed")
    shops = shops.where(heated_tobacco_status: :allowed) if @selected_filters.key?("heated_tobacco_allowed")
    shops = shops.where(wifi_available: true) if @selected_filters.key?("wifi_available")
    shops = shops.where(power_available: true) if @selected_filters.key?("power_available")
    shops = shops.joins(:tags).where(tags: { id: @selected_tag_ids }).distinct if @selected_tag_ids.any?
    shops
  end

  def selected_filters
    params.fetch(:filters, {}).permit(*FILTER_OPTIONS.keys, tag_ids: [])
      .slice(*FILTER_OPTIONS.keys)
      .to_h
      .select { |_, value| value == "1" }
  end

  def selected_tag_ids
    params.fetch(:filters, {}).permit(tag_ids: [])[:tag_ids]
      .to_a
      .reject(&:blank?)
      .map(&:to_i)
      .uniq
  end
end
