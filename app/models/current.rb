class Current < ActiveSupport::CurrentAttributes
  attribute :session

  # session レコードに紐づく user / admin を Current 経由で参照できるようにする
  # allow_nil: true でセッションが nil のとき（未ログイン時）でもエラーにならない
  delegate :user, to: :session, allow_nil: true
  delegate :admin, to: :session, allow_nil: true
end
