class LevelFramework
  SKILLS = {
    "programming_fundamentals" => ["Programming fundamentals", "Write clear code for a scoped task; explain edge cases."],
    "git_collaboration" => ["Git & collaboration", "Keep changes reviewable and respond constructively to feedback."],
    "testing_basics" => ["Testing basics", "Choose useful tests for expected behavior and common failures."],
    "api_development" => ["API development", "Design a consistent API with validation and useful errors."],
    "database_fundamentals" => ["Database fundamentals", "Model data and queries for a concrete use case."],
    "debugging" => ["Debugging", "Gather signals, isolate a cause, and verify the fix."],
    "technical_ownership" => ["Technical ownership", "Own a change from the problem through delivery and follow-up."],
    "code_quality" => ["Code quality", "Keep code understandable and reduce regression risk."],
    "delivery_planning" => ["Delivery planning", "Break down delivery, dependencies, risks, and completion criteria."],
    "system_design" => ["System design", "Explain requirements, failure modes, and trade-offs with evidence."],
    "mentoring_feedback" => ["Mentoring & feedback", "Help others grow with concrete goals and actionable feedback."],
    "cross_team_influence" => ["Cross-team influence", "Build agreement and manage dependencies across teams."],
    "technical_strategy" => ["Technical strategy", "Connect technical choices to product and organizational goals."],
    "architecture_at_scale" => ["Architecture at scale", "Design boundaries and operations across systems and teams."],
    "org_wide_influence" => ["Org-wide influence", "Create mechanisms that improve engineering across groups."],
    "customer_discovery" => ["Customer discovery", "Clarify outcomes, constraints, and success measures with stakeholders."],
    "integration_design" => ["Integration design", "Make contracts and failure handling clear between systems."],
    "solution_communication" => ["Solution communication", "Explain options, risk, and cost for decision makers."],
    "security_nfr" => ["Security & non-functional requirements", "Include security, availability, performance, and compliance in design."],
    "org_design" => ["Org design", "Clarify ownership, decision rights, and team coordination."],
    "business_alignment" => ["Business alignment", "Connect technology investment to outcomes and opportunity cost."]
  }.freeze

  COMMON_LEVELS = [
    { number: 1, name: "Fresher", focus: "Learn fundamentals and complete guided tasks.", skills: %w[programming_fundamentals git_collaboration testing_basics] },
    { number: 2, name: "Junior", focus: "Deliver a small feature independently within team standards.", skills: %w[api_development database_fundamentals debugging] },
    { number: 3, name: "Mid-level", focus: "Own part of a product and deliver independently.", skills: %w[technical_ownership code_quality delivery_planning] },
    { number: 4, name: "Senior", focus: "Solve ambiguous problems and lead technical decisions in a team.", skills: %w[system_design technical_ownership mentoring_feedback cross_team_influence] }
  ].freeze

  CAREER_PATHS = {
    "Staff Engineer" => { focus: "Extend technical direction and architecture across teams.", skills: %w[technical_strategy architecture_at_scale org_wide_influence] },
    "Solution Architect" => { focus: "Connect business needs with integrated, operable solutions.", skills: %w[architecture_at_scale customer_discovery solution_communication integration_design security_nfr] },
    "Technical Lead" => { focus: "Lead delivery, quality, and team capability.", skills: %w[delivery_planning mentoring_feedback cross_team_influence] },
    "CTO" => { focus: "Shape technology, organization, investment, and operations.", skills: %w[technical_strategy org_design business_alignment org_wide_influence] }
  }.freeze

  def self.skills
    SKILLS.map { |key, (name, description)| { key:, name:, description: } }
  end

  def self.levels_for(target_role)
    path = CAREER_PATHS.fetch(target_role, CAREER_PATHS.fetch("Staff Engineer"))
    COMMON_LEVELS + [{ number: 5, name: target_role, focus: path[:focus], skills: path[:skills] }]
  end
end
