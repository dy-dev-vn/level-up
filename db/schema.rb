# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_31_091000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "audit_events", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "actor_id", null: false
    t.string "action", null: false
    t.string "entity_type", null: false
    t.string "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_audit_events_on_actor_id"
    t.index ["owner_id", "created_at"], name: "index_audit_events_on_owner_id_and_created_at"
    t.index ["owner_id"], name: "index_audit_events_on_owner_id"
  end

  create_table "evidence_reviews", force: :cascade do |t|
    t.bigint "evidence_id", null: false
    t.bigint "reviewer_id", null: false
    t.string "decision", null: false
    t.text "note", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evidence_id", "created_at"], name: "index_evidence_reviews_on_evidence_id_and_created_at"
    t.index ["evidence_id"], name: "index_evidence_reviews_on_evidence_id"
    t.index ["reviewer_id"], name: "index_evidence_reviews_on_reviewer_id"
    t.check_constraint "decision::text = ANY (ARRAY['revision'::character varying, 'verified'::character varying]::text[])", name: "evidence_review_decision_allowed"
  end

  create_table "evidence_skills", force: :cascade do |t|
    t.bigint "evidence_id", null: false
    t.string "skill_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evidence_id", "skill_key"], name: "index_evidence_skills_on_evidence_id_and_skill_key", unique: true
    t.index ["evidence_id"], name: "index_evidence_skills_on_evidence_id"
    t.index ["skill_key"], name: "index_evidence_skills_on_skill_key"
  end

  create_table "evidences", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "work_experience_id"
    t.string "title", null: false
    t.string "format", null: false
    t.text "summary", null: false
    t.string "resource_url"
    t.string "status", default: "pending", null: false
    t.datetime "submitted_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "submitted_at"], name: "index_evidences_on_owner_id_and_submitted_at"
    t.index ["owner_id"], name: "index_evidences_on_owner_id"
    t.index ["work_experience_id"], name: "index_evidences_on_work_experience_id"
    t.check_constraint "format::text = ANY (ARRAY['application'::character varying, 'system_design'::character varying, 'document'::character varying, 'writing'::character varying]::text[])", name: "evidence_format_allowed"
    t.check_constraint "status::text = ANY (ARRAY['pending'::character varying, 'revision'::character varying, 'verified'::character varying]::text[])", name: "evidence_status_allowed"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "display_name", null: false
    t.string "headline", default: "", null: false
    t.string "discipline", default: "Software Engineering", null: false
    t.integer "claimed_level", default: 1, null: false
    t.integer "years_experience", default: 0, null: false
    t.string "target_role", default: "Staff Engineer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
    t.check_constraint "claimed_level >= 1 AND claimed_level <= 5", name: "profiles_claimed_level_range"
    t.check_constraint "years_experience >= 0 AND years_experience <= 60", name: "profiles_years_range"
  end

  create_table "review_scores", force: :cascade do |t|
    t.bigint "evidence_review_id", null: false
    t.string "criterion_key", null: false
    t.integer "score", null: false
    t.text "note", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evidence_review_id", "criterion_key"], name: "index_review_scores_on_evidence_review_id_and_criterion_key", unique: true
    t.index ["evidence_review_id"], name: "index_review_scores_on_evidence_review_id"
    t.check_constraint "score >= 0 AND score <= 3", name: "review_score_range"
  end

  create_table "reviewer_grants", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "reviewer_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "accepted_at"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "reviewer_id"], name: "index_reviewer_grants_on_owner_id_and_reviewer_id", unique: true
    t.index ["owner_id"], name: "index_reviewer_grants_on_owner_id"
    t.index ["reviewer_id", "status"], name: "index_reviewer_grants_on_reviewer_id_and_status"
    t.index ["reviewer_id"], name: "index_reviewer_grants_on_reviewer_id"
    t.check_constraint "owner_id <> reviewer_id", name: "reviewer_grant_not_self"
    t.check_constraint "status::text = ANY (ARRAY['pending'::character varying, 'accepted'::character varying, 'revoked'::character varying]::text[])", name: "reviewer_grant_status_allowed"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "work_experiences", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.string "role", null: false
    t.string "organization", default: "", null: false
    t.date "from_month", null: false
    t.date "to_month"
    t.boolean "is_current", default: false, null: false
    t.text "scope", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_work_experiences_on_profile_id"
    t.check_constraint "to_month IS NULL OR to_month >= from_month", name: "work_experiences_month_order"
  end

  add_foreign_key "audit_events", "users", column: "actor_id"
  add_foreign_key "audit_events", "users", column: "owner_id"
  add_foreign_key "evidence_reviews", "evidences", on_delete: :cascade
  add_foreign_key "evidence_reviews", "users", column: "reviewer_id"
  add_foreign_key "evidence_skills", "evidences", on_delete: :cascade
  add_foreign_key "evidences", "users", column: "owner_id"
  add_foreign_key "evidences", "work_experiences", on_delete: :nullify
  add_foreign_key "profiles", "users"
  add_foreign_key "review_scores", "evidence_reviews", on_delete: :cascade
  add_foreign_key "reviewer_grants", "users", column: "owner_id", on_delete: :cascade
  add_foreign_key "reviewer_grants", "users", column: "reviewer_id", on_delete: :cascade
  add_foreign_key "sessions", "users"
  add_foreign_key "work_experiences", "profiles", on_delete: :cascade
end
