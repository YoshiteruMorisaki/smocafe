class Public::ReportsController < Public::ApplicationController
  before_action :set_shop, only: [:index, :new, :create]
  before_action :set_report, only: [:edit, :update, :destroy]

  def index
    @reports = paginate_collection(
      @shop.reports.includes(:user).order(visited_on: :desc, created_at: :desc, id: :desc)
    )
  end

  def new
    @report = @shop.reports.build(default_report_attributes)
    @tags = Tag.alphabetical
  end

  def create
    @report = @shop.reports.build(report_params)
    @report.user = current_user

    if @report.save
      add_tags_to_shop(@shop)
      redirect_to shop_path(@shop), notice: "投稿を保存しました。"
    else
      @tags = Tag.alphabetical
      flash.now[:alert] = "投稿に失敗しました。入力内容をご確認ください。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shop = @report.shop
    @tags = Tag.alphabetical
  end

  def update
    @shop = @report.shop

    if @report.update(report_params)
      add_tags_to_shop(@shop)
      redirect_to users_my_page_path, notice: "投稿を更新しました。"
    else
      @tags = Tag.alphabetical
      flash.now[:alert] = "更新に失敗しました。入力内容をご確認ください。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to users_my_page_path, notice: "投稿を削除しました。"
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:visited_on, :heated_tobacco_status, :papper_tobacco_status, :comment)
  end

  def add_tags_to_shop(shop)
    tag_ids = Array(params.dig(:report, :tag_ids)).map(&:to_i).uniq
    Tag.where(id: tag_ids).each do |tag|
      ShopTag.find_or_create_by(shop: shop, tag: tag)
    end
  end

  def default_report_attributes
    {
      visited_on: Date.current,
      heated_tobacco_status: @shop.heated_tobacco_status,
      papper_tobacco_status: @shop.papper_tobacco_status
    }
  end
end
