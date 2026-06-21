# wsite

A small blog application built **milestone by milestone** as a hands-on way to learn —
or refresh — modern **Ruby on Rails 8**. It grows from a fresh scaffold into a working
blog with **live comments** (Hotwire), a full **test suite**, a **background job**
(Solid Queue), and a **deployable Docker/Kamal** setup. Each milestone is a single git
commit, so the history doubles as a study log.

📚 **Start here: the [Learning Path](docs/README.md)** — a guided walkthrough of all six
milestones.

## Tech stack

Rails 8.1 · SQLite · Propshaft (assets) · importmap (JS, no bundler) ·
Hotwire (Turbo + Stimulus) · Solid Queue / Solid Cache / Solid Cable ·
Kamal (deploy) · Minitest + Capybara (tests).

## Getting started

Ruby is managed by [rbenv](https://github.com/rbenv/rbenv) — see the version in
[`.ruby-version`](.ruby-version). In a non-login shell you may need to load it first:

```bash
export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init - bash)"
```

Then install gems, prepare the databases, and run the app:

```bash
bin/setup --skip-server   # bundle install + db:prepare
bin/rails server          # http://localhost:3000
```

## Common commands

```bash
bin/rails server          # run the app
bin/rails console         # interactive console
bin/rails test            # model + integration tests
bin/rails test:system     # browser tests (needs Chromium)
bin/rails test:all        # everything
bin/jobs                  # run the Solid Queue background worker
bin/rubocop               # style/lint
bin/brakeman              # security scan
```

## Learning path

| #  | Guide | What you learn |
|----|-------|----------------|
| 0  | [Setup & orientation](docs/00-setup-and-orientation.md) | Boot the app, MVC layout, `/up` health check |
| 1  | [Scaffold a Post](docs/01-scaffold-post.md) | Generators, migrations, REST routes, strong params, CSRF |
| 2  | [Validations & associations](docs/02-validations-and-associations.md) | Validations, `has_many`/`belongs_to`, the console |
| 3  | [Testing](docs/03-testing.md) | The test pyramid: model, integration, system |
| 4  | [Hotwire](docs/04-hotwire.md) | Turbo + Stimulus, importmap (no Node build) |
| 5  | [Background jobs](docs/05-solid-queue-jobs.md) | ActiveJob + Solid Queue (no Redis) |
| 6  | [Quality & deploy](docs/06-quality-and-deploy.md) | RuboCop, Brakeman, Kamal + Docker |
