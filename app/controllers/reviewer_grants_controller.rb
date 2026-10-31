class ReviewerGrantsController < ApplicationController
  def index
    render inertia: "reviewers/index", props: {
      sent: current_user.sent_reviewer_grants.includes(:reviewer).map { |grant| grant_props(grant, :reviewer) },
      received: current_user.received_reviewer_grants.includes(:owner).map { |grant| grant_props(grant, :owner) }
    }
  end

  def create
    reviewer = User.find_by(email_address: params.require(:reviewer_email).strip.downcase)
    return redirect_to reviewer_grants_path, alert: "That account could not be found." unless reviewer
    return redirect_to reviewer_grants_path, alert: "You cannot review your own evidence." if reviewer == current_user

    grant = current_user.sent_reviewer_grants.find_or_initialize_by(reviewer:)
    grant.assign_attributes(status: "pending", accepted_at: nil, revoked_at: nil)
    grant.save!
    AuditEvent.create!(owner: current_user, actor: current_user, action: "reviewer.invited", entity_type: "reviewer_grant", entity_id: grant.id.to_s)
    redirect_to reviewer_grants_path, notice: "Reviewer invitation created."
  end

  def update
    grant = ReviewerGrant.find(params[:id])
    case params.require(:decision)
    when "accept"
      return head :forbidden unless grant.reviewer_id == current_user.id && grant.status == "pending"

      grant.update!(status: "accepted", accepted_at: Time.current)
      actor = current_user
    when "revoke"
      return head :forbidden unless grant.owner_id == current_user.id

      grant.update!(status: "revoked", revoked_at: Time.current)
      actor = current_user
    else
      return head :unprocessable_entity
    end
    AuditEvent.create!(owner_id: grant.owner_id, actor:, action: "reviewer.#{grant.status}", entity_type: "reviewer_grant", entity_id: grant.id.to_s)
    redirect_to reviewer_grants_path, notice: "Reviewer access updated."
  end

  private

  def grant_props(grant, user_key)
    grant.as_json(only: %i[id status created_at accepted_at]).merge(user: grant.public_send(user_key).as_json(only: %i[id email_address]))
  end
end
