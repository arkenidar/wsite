# wsite — Rails 8 Learning Path

`wsite` is a small blog application built **milestone by milestone** as a hands-on way
to learn (or refresh) modern **Ruby on Rails 8**. Each milestone adds one slice of the
stack — CRUD, validations, tests, Hotwire, background jobs, deployment — and corresponds
to a single git commit, so the project's history doubles as a study log.

By the end you have a working blog with **live comments** (no full page reloads),
a full **test suite** (model → integration → browser), a **background job**, and a
**deployable Docker/Kamal** setup.

## The milestones

| #  | Guide | What you learn |
|----|-------|----------------|
| 0  | [Setup & orientation](00-setup-and-orientation.md) | Boot the app, MVC layout, the `/up` health check |
| 1  | [Scaffold a Post](01-scaffold-post.md) | Generators, migrations, REST routes, strong params, CSRF |
| 2  | [Validations & associations](02-validations-and-associations.md) | ActiveRecord validations, `has_many`/`belongs_to`, the console |
| 3  | [Testing](03-testing.md) | The test pyramid: model, integration, and system (browser) tests |
| 4  | [Hotwire](04-hotwire.md) | Turbo Drive/Frames/Streams + Stimulus, importmap (no Node build) |
| 5  | [Background jobs](05-solid-queue-jobs.md) | ActiveJob + Solid Queue (DB-backed, no Redis), `bin/jobs` |
| 6  | [Quality & deploy](06-quality-and-deploy.md) | RuboCop, Brakeman, bundler-audit, Kamal + Docker |

Read them in order — each builds on the last. Every guide ends with a **Verify** step
and the **commit** it maps to, so you can `git show <subject>` to see the exact diff.

## Tech stack

Rails 8.1 · SQLite · Propshaft (assets) · importmap (JS, no bundler) ·
Hotwire (Turbo + Stimulus) · Solid Queue / Solid Cache / Solid Cable ·
Kamal (deploy) · Minitest + Capybara (tests).

## Prerequisites

- **Ruby** managed by [rbenv](https://github.com/rbenv/rbenv) (this repo uses the version
  pinned in [`.ruby-version`](../.ruby-version)). In a non-login shell you may need to load it:

  ```bash
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - bash)"
  ```

- **A Chromium/Chrome browser** — required for the system (browser) tests in Milestone 3+.
- First-time setup installs gems and prepares the databases:

  ```bash
  bin/setup            # bundle install + db:prepare + start the dev server
  # or, without starting the server:
  bin/setup --skip-server
  ```

## Everyday commands

```bash
bin/rails server          # run the app at http://localhost:3000
bin/rails console         # interactive Ruby with your app loaded
bin/rails test            # model + integration tests
bin/rails test:system     # browser (Capybara) tests
bin/rails test:all        # everything
bin/jobs                  # run the Solid Queue background worker
bin/rubocop               # style/lint (omakase)
bin/brakeman              # static security scan
```

See the project [README](../README.md) for a high-level overview.
