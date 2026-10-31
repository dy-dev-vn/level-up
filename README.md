# Level Up

Level Up is a Rails + React application for turning career claims into reviewable evidence. A profile records a target role and work history; evidence links an artifact to skills; invited reviewers score evidence against a shared rubric. The MVP ships with a small role/level framework and can be extended with rubric authoring and progression rules.

## Stack

- Ruby 3.2.2, Rails 8.1, PostgreSQL 17, Puma
- React 19 + TypeScript, Inertia Rails, Vite 8
- Tailwind CSS 4 with the existing shadcn-style UI components
- Rails authentication generator with bcrypt; no external auth service required for local development

## Requirements

- rbenv with Ruby 3.2.2 and Bundler 2.6+
- Node.js 22+
- Docker Compose (or a local PostgreSQL 17 server)

## Run locally

```sh
rbenv install 3.2.2 # skip if already installed
rbenv local 3.2.2
 gem install bundler -v 2.6.9
bundle _2.6.9_ install
npm install
docker compose up -d db
bin/rails db:prepare
bin/dev
```

Open http://localhost:3000. Register a user, complete the profile, add an evidence item, and invite another registered user as a reviewer. The reviewer accepts the invitation and reviews items in the workspace.

If PostgreSQL runs outside Compose, configure `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_HOST`, and `POSTGRES_PORT`. Production uses `DATABASE_URL`.

## Useful commands

```sh
npm run check
npx vite build
bin/rails routes
bin/rails db:migrate
```

## Structure

```text
app/controllers/       Rails endpoints and authorization
app/models/            Profile, work history, evidence, reviews, audit trail
app/services/          Career level and skill framework
app/frontend/pages/    Inertia React screens
app/frontend/components/ui/  Existing shadcn-style component kit
app/frontend/entrypoints/    Vite CSS and Inertia boot
config/                Rails, database, routes, Vite configuration
db/migrate/            Authentication and product schema
compose.yaml           Local PostgreSQL service
```

## Product boundaries

Level Up reports evidence coverage and reviewer decisions. It is not an employment guarantee or an automatic hiring score. Rubrics and level thresholds are starter data and should be reviewed before using them for consequential decisions.
