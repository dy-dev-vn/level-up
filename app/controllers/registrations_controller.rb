class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    render inertia: "auth/register"
  end

  def create
    user = User.new(registration_params)
    if user.save
      start_new_session_for(user)
      redirect_to root_path, notice: "Welcome to LevelUp."
    else
      render inertia: "auth/register", props: { errors: user.errors.to_hash }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
