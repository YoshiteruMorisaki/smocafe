class Public::HomesController < Public::ApplicationController
  allow_unauthenticated_access only: %i[top about]

  def top
    @new_shops = Shop.newest_first.limit(5)
    @recently_updated_shops = Shop.recent_first.limit(5)
  end

  def about; end
end
