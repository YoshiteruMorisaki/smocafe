class Admin::TagsController < Admin::ApplicationController
  before_action :set_tag, only: %i[edit update destroy]

  def index
    @tags = paginate_collection(Tag.alphabetical)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to admin_tags_path, notice: "タグを登録しました。"
    else
      flash.now[:alert] = "タグの登録に失敗しました。入力内容をご確認ください。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @tag.update(tag_params)
      redirect_to admin_tags_path, notice: "タグ情報を更新しました。"
    else
      flash.now[:alert] = "タグ情報の更新に失敗しました。入力内容をご確認ください。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_path, notice: "タグを削除しました。"
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
