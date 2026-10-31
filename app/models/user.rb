class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :owned_evidence, class_name: "Evidence", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
  has_many :sent_reviewer_grants, class_name: "ReviewerGrant", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
  has_many :received_reviewer_grants, class_name: "ReviewerGrant", foreign_key: :reviewer_id, inverse_of: :reviewer, dependent: :destroy
  has_many :evidence_reviews, foreign_key: :reviewer_id, inverse_of: :reviewer, dependent: :restrict_with_error

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
