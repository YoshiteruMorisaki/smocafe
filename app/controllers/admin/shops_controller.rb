class Admin::ShopsController < Admin::ApplicationController
  before_action :set_shop, only: %i[edit update destroy]

  def index
    @shops = paginate_collection(Shop.recent_first)
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)

    if @shop.save
      redirect_to admin_shops_path, notice: "店舗を登録しました。"
    else
      flash.now[:alert] = "店舗の登録に失敗しました。入力内容をご確認ください。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @shop.update(shop_params)
      redirect_to admin_shops_path, notice: "店舗情報を更新しました。"
    else
      flash.now[:alert] = "店舗情報の更新に失敗しました。入力内容をご確認ください。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shop.destroy
    redirect_to admin_shops_path, notice: "店舗を削除しました。"
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(
      :name,
      :area,
      :address,
      :business_hours,
      :closed_days,
      :heated_tobacco_status,
      :papper_tobacco_status,
      :wifi_available,
      :power_available,
      :description,
      :last_reported_at,
      :image
    )
  end
end
