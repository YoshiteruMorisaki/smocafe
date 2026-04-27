class Admin::ReportsController < Admin::ApplicationController
  before_action :set_report, only: [ :destroy ]

  def index
    # includes(:user, :shop) で管理画面一覧のユーザー名・店舗名表示 N+1 を防止
    @reports = paginate_collection(
      Report.includes(:user, :shop).order(created_at: :desc, id: :desc)
    )
  end

  def destroy
    @report.destroy
    redirect_to admin_reports_path, notice: "投稿を削除しました。"
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end
end
