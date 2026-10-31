class EvidenceReviewsController < ApplicationController
  def create
    item = Evidence.joins("INNER JOIN reviewer_grants ON reviewer_grants.owner_id = evidence.owner_id")
      .where(reviewer_grants: { reviewer_id: current_user.id, status: "accepted" })
      .where.not(owner_id: current_user.id).find(params[:evidence_id])
    return head :conflict if item.status == "verified"

    input = review_params
    scores = input[:scores].to_a
    return head :unprocessable_entity unless scores.map { |score| score[:criterion_key] }.sort == ReviewScore::CRITERIA.sort
    return head :unprocessable_entity if scores.any? { |score| !score[:score].to_s.match?(/\A[0-3]\z/) }
    return redirect_to reviewer_workspace_path(id: item.id), alert: "Add a specific reason before requesting changes." if input[:decision] == "revision" && input[:note].to_s.strip.length < 8

    Evidence.transaction do
      review = item.evidence_reviews.create!(reviewer: current_user, decision: input[:decision], note: input[:note])
      scores.each { |score| review.review_scores.create!(score.permit(:criterion_key, :score, :note)) }
      item.update!(status: input[:decision])
      AuditEvent.create!(owner: item.owner, actor: current_user, action: "evidence.review.#{input[:decision]}", entity_type: "evidence", entity_id: item.id.to_s)
    end
    redirect_to reviewer_workspace_index_path, notice: "Review recorded."
  end

  private

  def review_params
    params.require(:review).permit(:decision, :note, scores: %i[criterion_key score note])
  end
end
