class CreateLevelupDomain < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :display_name, null: false
      t.string :headline, null: false, default: ""
      t.string :discipline, null: false, default: "Software Engineering"
      t.integer :claimed_level, null: false, default: 1
      t.integer :years_experience, null: false, default: 0
      t.string :target_role, null: false, default: "Staff Engineer"
      t.timestamps
    end
    add_check_constraint :profiles, "claimed_level BETWEEN 1 AND 5", name: "profiles_claimed_level_range"
    add_check_constraint :profiles, "years_experience BETWEEN 0 AND 60", name: "profiles_years_range"

    create_table :work_experiences do |t|
      t.references :profile, null: false, foreign_key: { on_delete: :cascade }
      t.string :role, null: false
      t.string :organization, null: false, default: ""
      t.date :from_month, null: false
      t.date :to_month
      t.boolean :is_current, null: false, default: false
      t.text :scope, null: false, default: ""
      t.timestamps
    end
    add_check_constraint :work_experiences, "to_month IS NULL OR to_month >= from_month", name: "work_experiences_month_order"

    create_table :evidences do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :work_experience, foreign_key: { on_delete: :nullify }
      t.string :title, null: false
      t.string :format, null: false
      t.text :summary, null: false
      t.string :resource_url
      t.string :status, null: false, default: "pending"
      t.datetime :submitted_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamps
    end
    add_index :evidences, [:owner_id, :submitted_at]
    add_check_constraint :evidences, "format IN ('application', 'system_design', 'document', 'writing')", name: "evidence_format_allowed"
    add_check_constraint :evidences, "status IN ('pending', 'revision', 'verified')", name: "evidence_status_allowed"

    create_table :evidence_skills do |t|
      t.references :evidence, null: false, foreign_key: { on_delete: :cascade }
      t.string :skill_key, null: false
      t.timestamps
    end
    add_index :evidence_skills, [:evidence_id, :skill_key], unique: true
    add_index :evidence_skills, :skill_key

    create_table :reviewer_grants do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :reviewer, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.string :status, null: false, default: "pending"
      t.datetime :accepted_at
      t.datetime :revoked_at
      t.timestamps
    end
    add_index :reviewer_grants, [:owner_id, :reviewer_id], unique: true
    add_index :reviewer_grants, [:reviewer_id, :status]
    add_check_constraint :reviewer_grants, "owner_id <> reviewer_id", name: "reviewer_grant_not_self"
    add_check_constraint :reviewer_grants, "status IN ('pending', 'accepted', 'revoked')", name: "reviewer_grant_status_allowed"

    create_table :evidence_reviews do |t|
      t.references :evidence, null: false, foreign_key: { on_delete: :cascade }
      t.references :reviewer, null: false, foreign_key: { to_table: :users }
      t.string :decision, null: false
      t.text :note, null: false, default: ""
      t.timestamps
    end
    add_index :evidence_reviews, [:evidence_id, :created_at]
    add_check_constraint :evidence_reviews, "decision IN ('revision', 'verified')", name: "evidence_review_decision_allowed"

    create_table :review_scores do |t|
      t.references :evidence_review, null: false, foreign_key: { on_delete: :cascade }
      t.string :criterion_key, null: false
      t.integer :score, null: false
      t.text :note, null: false, default: ""
      t.timestamps
    end
    add_index :review_scores, [:evidence_review_id, :criterion_key], unique: true
    add_check_constraint :review_scores, "score BETWEEN 0 AND 3", name: "review_score_range"

    create_table :audit_events do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.string :action, null: false
      t.string :entity_type, null: false
      t.string :entity_id, null: false
      t.timestamps
    end
    add_index :audit_events, [:owner_id, :created_at]
  end
end
