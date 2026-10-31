class EvidenceReview < ApplicationRecord
  DECISIONS = %w[revision verified].freeze

  belongs_to :evidence
  belongs_to :reviewer, class_name: "User"
  has_many :review_scores, dependent: :destroy

  validates :decision, inclusion: { in: DECISIONS }
  validate :reviewer_has_access

  private

  def reviewer_has_access
    return if evidence.blank? || reviewer.blank?
    return if evidence.owner_id != reviewer_id && ReviewerGrant.exists?(owner_id: evidence.owner_id, reviewer_id:, status: "accepted")

    errors.add(:reviewer, "does not have accepted access to this evidence")
  end
end
