class ProfilesController < ApplicationController
  def edit
    profile = current_user.profile || current_user.build_profile(display_name: current_user.email_address.split("@").first)
    render inertia: "profiles/edit", props: {
      profile: profile.as_json(only: %i[display_name headline discipline claimed_level years_experience target_role]).merge(
        work_experiences: profile.work_experiences.order(from_month: :desc).as_json(only: %i[id role organization from_month to_month is_current scope])
      ),
      levels: levels_for(profile.target_role),
      roles: LevelFramework::CAREER_PATHS.keys.map { |role| { key: role, label: role } }
    }
  end

  def update
    profile = current_user.profile || current_user.build_profile
    if profile.update(profile_params)
      AuditEvent.create!(owner: current_user, actor: current_user, action: "profile.updated", entity_type: "profile", entity_id: profile.id.to_s)
      redirect_to root_path, notice: "Profile saved."
    else
      render inertia: "profiles/edit", props: {
        profile: profile.as_json(only: %i[display_name headline discipline claimed_level years_experience target_role]).merge(work_experiences: profile.work_experiences.as_json),
        levels: levels_for(profile.target_role),
        roles: LevelFramework::CAREER_PATHS.keys.map { |role| { key: role, label: role } },
        errors: profile.errors.to_hash
      }, status: :unprocessable_entity
    end
  end

  private

  def levels_for(target_role)
    LevelFramework.levels_for(target_role).map { |level| { key: level[:number], label: level[:name] } }
  end

  def profile_params
    params.require(:profile).permit(
      :display_name, :headline, :discipline, :claimed_level, :years_experience, :target_role,
      work_experiences_attributes: %i[id role organization from_month to_month is_current scope _destroy]
    )
  end
end
