class Profile < ApplicationRecord
  belongs_to :user
  has_many :work_experiences, dependent: :destroy
  accepts_nested_attributes_for :work_experiences, allow_destroy: true, reject_if: :all_blank

  validates :display_name, :headline, :discipline, :target_role, presence: true
  validates :claimed_level, inclusion: { in: 1..5 }
  validates :years_experience, numericality: { only_integer: true, in: 0..60 }
end
