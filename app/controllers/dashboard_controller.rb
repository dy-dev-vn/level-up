class DashboardController < ApplicationController
  def index
    profile = current_user.profile
    evidence = current_user.owned_evidence.includes(:evidence_skills).order(submitted_at: :desc)
    inbox = Evidence.joins("INNER JOIN reviewer_grants ON reviewer_grants.owner_id = evidences.owner_id")
      .where(reviewer_grants: { reviewer_id: current_user.id, status: "accepted" }, status: %w[pending revision])
      .includes(:owner)

    render inertia: "dashboard/index", props: {
      current_user: { id: current_user.id, email: current_user.email_address },
      profile: profile&.as_json(only: %i[id display_name headline discipline claimed_level years_experience target_role]),
      levels: LevelFramework.levels_for(profile&.target_role),
      skills: LevelFramework.skills,
      evidence: evidence.map { |item| evidence_props(item) },
      review_inbox_count: inbox.count
    }
  end

  private

  def evidence_props(item)
    item.as_json(only: %i[id title format summary status submitted_at]).merge(skills: item.evidence_skills.map(&:skill_key))
  end
end
