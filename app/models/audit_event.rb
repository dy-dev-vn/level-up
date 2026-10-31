class AuditEvent < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :actor, class_name: "User"

  validates :action, :entity_type, :entity_id, presence: true
end
