 Rails.application.routes.draw do
  # ------------------------------
  # 一般ユーザー向けルーティング
  # `scope module: :public` により、Public::配下のコントローラを参照します。
  # ------------------------------
  scope module: :public do
    # トップページ / About
    root "homes#top"
    get "about", to: "homes#about"

    # 会員登録 / ログイン
    get "users/sign_up", to: "registrations#new"
    post "users", to: "registrations#create"

    get "users/sign_in", to: "sessions#new"
    post "users/sign_in", to: "sessions#create"
    delete "users/sign_out", to: "sessions#destroy"

    # マイページ / 会員情報編集 / 退会
    get "users/my_page", to: "users#show"
    get "users/information/edit", to: "users#edit"
    patch "users", to: "users#update"
    get "users/unsubscribe", to: "users#unsubscribe"
    patch "users/withdraw", to: "users#withdraw"

    # カフェ一覧・詳細
    # 各店舗に対してレビュー投稿とブックマーク登録をネストしています。
    resources :shops, only: [:index, :show] do
      resources :reports, only: [:new, :create]
      resource :bookmark, only: [:create, :destroy]
    end

    # 投稿済みレビューの編集 / 削除、ブックマーク一覧
    resources :reports, only: [:edit, :update, :destroy]
    resources :bookmarks, only: [:index]
  end

  # ------------------------------
  # 管理者向けルーティング
  # URL は `/admin/...` になり、Admin::配下のコントローラを参照します。
  # ------------------------------
  namespace :admin do
    root "homes#top"

    # 管理者ログイン
    get "sign_in", to: "sessions#new"
    post "sign_in", to: "sessions#create"
    delete "sign_out", to: "sessions#destroy"

    # 管理画面で扱う主要リソース
    resources :shops, except: [:show]
    resources :reports, only: [:index, :destroy]
    resources :tags, except: [:show]
  end
end
