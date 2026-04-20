class Admin::ReportsController < Admin::ApplicationController
  before_action :set_report, only: [:destroy]

  def index
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
