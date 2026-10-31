class WorkExperience < ApplicationRecord
  belongs_to :profile
  has_many :evidence, dependent: :nullify

  validates :role, :from_month, presence: true
  validate :only_one_current_position
  validate :end_month_after_start

  private

  def only_one_current_position
    return unless is_current?
    return if profile.work_experiences.where(is_current: true).where.not(id: id).none?

    errors.add(:is_current, "already exists for this profile")
  end

  def end_month_after_start
    return if to_month.blank? || from_month.blank? || to_month >= from_month

    errors.add(:to_month, "must not be before the start month")
  end
end
