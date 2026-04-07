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
    @selected_area = params[:area].presence_in(@areas)
    @selected_filters = selected_filters
    @total_shops_count = Shop.count
    @shops = paginate_collection(filtered_shops)
  end

  def show
    @shop = Shop.find(params[:id])
  end

  private

  def filtered_shops
    shops = Shop.recent_first
    shops = shops.by_area(@selected_area) if @selected_area.present?
    shops = shops.where(papper_tobacco_status: :allowed) if @selected_filters.key?("papper_tobacco_allowed")
    shops = shops.where(heated_tobacco_status: :allowed) if @selected_filters.key?("heated_tobacco_allowed")
    shops = shops.where(wifi_available: true) if @selected_filters.key?("wifi_available")
    shops = shops.where(power_available: true) if @selected_filters.key?("power_available")
    shops
  end

  def selected_filters
    params.fetch(:filters, {}).permit(*FILTER_OPTIONS.keys).to_h.select { |_, value| value == "1" }
  end
end
