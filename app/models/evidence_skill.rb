class EvidenceSkill < ApplicationRecord
  belongs_to :evidence
  validates :skill_key, presence: true, uniqueness: { scope: :evidence_id }
end
