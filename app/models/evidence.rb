class Evidence < ApplicationRecord
  FORMATS = %w[application system_design document writing].freeze
  STATUSES = %w[pending revision verified].freeze

  belongs_to :owner, class_name: "User"
  belongs_to :work_experience, optional: true
  has_many :evidence_skills, dependent: :destroy
  has_many :evidence_reviews, dependent: :destroy
  has_many :reviewer_grants, through: :owner, source: :sent_reviewer_grants

  attr_accessor :skill_keys

  validates :title, length: { in: 3..100 }
  validates :summary, length: { in: 30..1_400 }
  validates :format, inclusion: { in: FORMATS }
  validates :status, inclusion: { in: STATUSES }
  validates :resource_url, format: { with: URI::DEFAULT_PARSER.make_regexp(["https"]), allow_blank: true }
  validate :skill_keys_are_supported

  private

  def skill_keys_are_supported
    keys = Array(skill_keys).reject(&:blank?).uniq
    errors.add(:skill_keys, "must include supported skills") if keys.empty? || (keys - LevelFramework::SKILLS.keys).any?
  end
end
