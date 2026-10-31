class ReviewerWorkspaceController < ApplicationController
  def index
    render inertia: "reviewers/workspace", props: { evidence: inbox.map { |item| evidence_props(item) } }
  end

  def show
    item = accessible_evidence.find(params[:id])
    render inertia: "reviews/show", props: {
      evidence: evidence_props(item),
      criteria: ReviewScore::CRITERIA.map { |key| { key:, label: key.humanize } }
    }
  end

  private

  def inbox
    accessible_evidence.where(status: %w[pending revision]).includes(:owner).order(submitted_at: :asc)
  end

  def accessible_evidence
    Evidence.joins("INNER JOIN reviewer_grants ON reviewer_grants.owner_id = evidence.owner_id")
      .where(reviewer_grants: { reviewer_id: current_user.id, status: "accepted" })
      .where.not(owner_id: current_user.id)
  end

  def evidence_props(item)
    item.as_json(only: %i[id title format summary resource_url status submitted_at])
      .merge(owner_email: item.owner.email_address, skills: item.evidence_skills.map(&:skill_key))
  end
end
