class Public::ShopsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @areas = Shop::AREAS
    @selected_area = params[:area].presence_in(@areas)
    @total_shops_count = Shop.count
    @shops = Shop.recent_first
    @shops = @shops.by_area(@selected_area) if @selected_area.present?
  end

  def show
    @shop = Shop.find(params[:id])
  end
end
