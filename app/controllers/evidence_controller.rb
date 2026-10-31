class EvidenceController < ApplicationController
  def index
    evidence = current_user.owned_evidence.includes(:evidence_skills).order(submitted_at: :desc)
    render inertia: "evidence/index", props: {
      evidence: evidence.map { |item| item.as_json(only: %i[id title format summary resource_url status submitted_at]).merge(skills: item.evidence_skills.map(&:skill_key)) },
      skills: LevelFramework.skills
    }
  end

  def new
    render inertia: "evidence/new", props: {
      positions: current_user.profile&.work_experiences&.order(from_month: :desc)&.as_json(only: %i[id role organization]) || [],
      skills: LevelFramework.skills
    }
  end

  def create
    input = evidence_params
    evidence = current_user.owned_evidence.new(input.except(:skill_keys))
    evidence.skill_keys = input[:skill_keys]
    if evidence.invalid?
      return render inertia: "evidence/new", props: { positions: position_options, skills: LevelFramework.skills, errors: evidence.errors.to_hash }, status: :unprocessable_entity
    end

    Evidence.transaction do
      evidence.save!
      Array(evidence.skill_keys).uniq.each { |key| evidence.evidence_skills.create!(skill_key: key) }
      AuditEvent.create!(owner: current_user, actor: current_user, action: "evidence.submitted", entity_type: "evidence", entity_id: evidence.id.to_s)
    end
    redirect_to evidence_index_path, notice: "Evidence submitted for review."
  rescue ActiveRecord::RecordInvalid
    render inertia: "evidence/new", props: { positions: position_options, skills: LevelFramework.skills, errors: evidence.errors.to_hash }, status: :unprocessable_entity
  end

  private

  def position_options
    current_user.profile&.work_experiences&.order(from_month: :desc)&.as_json(only: %i[id role organization]) || []
  end

  def evidence_params
    params.require(:evidence).permit(:title, :format, :summary, :resource_url, :work_experience_id, skill_keys: [])
  end
end
