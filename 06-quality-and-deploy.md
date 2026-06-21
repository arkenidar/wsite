# Milestone 6 — Quality & Deploy

**Goal:** see how a Rails 8 app stays healthy and how it ships.

## Concepts you'll learn

- The bundled **quality/security** tools: RuboCop, Brakeman, bundler-audit.
- **Kamal** + **Docker** deployment (Rails 8's built-in story).

## Quality & security tooling

All three ship by default — no gem hunting, and they're what CI runs
(see [`.github/workflows/`](https://github.com/arkenidar/wsite/blob/main/.github/workflows/)):

```bash
bin/rubocop          # style/lint; bin/rubocop -a auto-fixes most issues
bin/brakeman         # static security scan (SQLi, XSS, mass assignment, …)
bin/bundler-audit    # check Gemfile.lock against a CVE database
```

- **RuboCop** is configured by [`.rubocop.yml`](https://github.com/arkenidar/wsite/blob/main/.rubocop.yml), which inherits
  `rubocop-rails-omakase` (the Rails house style).
- **Brakeman** runs 80+ checks against your code. This app passes clean partly because
  `params.expect` and ERB auto-escaping protect you by default.

Run them before committing.

## Deployment with Kamal

[`config/deploy.yml`](https://github.com/arkenidar/wsite/blob/main/config/deploy.yml) defines the deploy. Kamal builds the Docker
image, pushes it to a registry, and runs it on your servers over SSH with zero-downtime
swaps. Notable settings:

- `servers:` — the target hosts.
- `volumes: wsite_storage:/rails/storage` — persists the SQLite databases (primary +
  queue + cache) across deploys.
- `SOLID_QUEUE_IN_PUMA: true` — runs the background worker *inside* the web process, so
  you deploy a single container (no separate worker).
- `RAILS_MASTER_KEY` (secret) — decrypts `config/credentials.yml.enc` in production.

## The Dockerfile

[`Dockerfile`](https://github.com/arkenidar/wsite/blob/main/Dockerfile) is a multi-stage build:

- a `build` stage compiles gems and precompiles assets;
- a slim `base` stage runs the app as a **non-root** `rails` user;
- `CMD ["./bin/thrust", "./bin/rails", "server"]` — **Thruster** sits in front of Puma
  for HTTP caching, compression, and X-Sendfile, replacing the need for nginx.

The result: a single `kamal deploy` takes this repo to a fresh server with Docker — no
Capistrano, no PaaS, no Kubernetes required.

## Verify

```bash
bin/rubocop          # => no offenses
bin/brakeman -q      # => no warnings
bin/bundler-audit    # => no vulnerabilities
```

## Where to go next

Keep practising on this repo:

- **Authentication** — Rails 8 ships a generator: `bin/rails generate authentication`.
- **Real-time comments across browsers** — `turbo_stream_from` + model `broadcasts`
  (Turbo + Solid Cable). Open two tabs and watch them sync.
- **Image uploads** — Active Storage (the `image_processing` gem is already in the Gemfile).

## Done

You've completed the path — back to the [index](README.md).
