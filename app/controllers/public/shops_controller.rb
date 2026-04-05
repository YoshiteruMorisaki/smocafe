class Public::ShopsController < Public::ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @shops = Shop.recent_first
  end

  def show
    @shop = Shop.find(params[:id])
  end
end
