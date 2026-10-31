class ReviewerGrant < ApplicationRecord
  STATUSES = %w[pending accepted revoked].freeze

  belongs_to :owner, class_name: "User"
  belongs_to :reviewer, class_name: "User"

  validates :status, inclusion: { in: STATUSES }
  validates :reviewer_id, uniqueness: { scope: :owner_id }
  validate :owner_cannot_review_self

  private

  def owner_cannot_review_self
    errors.add(:reviewer, "must be a different account") if owner_id.present? && owner_id == reviewer_id
  end
end
