class ReviewScore < ApplicationRecord
  CRITERIA = %w[scope_assumptions tradeoffs reliability ownership_learning].freeze

  belongs_to :evidence_review
  validates :criterion_key, inclusion: { in: CRITERIA }, uniqueness: { scope: :evidence_review_id }
  validates :score, numericality: { only_integer: true, in: 0..3 }
end
