class ApplicationController < ActionController::Base
  include Authentication
  helper_method :current_user
  inertia_share flash: -> { { notice: flash[:notice], alert: flash[:alert] } }
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def current_user
    Current.user
  end
end
