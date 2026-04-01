class Public::HomesController < Public::ApplicationController
  allow_unauthenticated_access only: %i[top about]

  def top; end

  def about; end
end
