class Current < ActiveSupport::CurrentAttributes
  attribute :session

  delegate :user, to: :session, allow_nil: true
  delegate :admin, to: :session, allow_nil: true
end
