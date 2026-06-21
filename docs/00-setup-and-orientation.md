# Milestone 0 — Setup & Orientation

**Goal:** get the app running and re-familiarize yourself with where things live.

## Concepts you'll learn

- The **MVC** directory layout of a Rails app.
- The request lifecycle: route → controller → view.
- The built-in `/up` **health check**.

## Steps

```bash
# Load Ruby (rbenv) in a non-login shell if needed:
export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init - bash)"

bin/setup --skip-server   # install gems + prepare the databases
bin/rails server          # boot Puma on http://localhost:3000
```

Visit:

- <http://localhost:3000> — the app (a Rails welcome page until Milestone 1).
- <http://localhost:3000/up> — the health check. Returns **HTTP 200** (green) if the
  app boots with no exceptions, **500** otherwise. Load balancers and uptime monitors
  hit this endpoint.

## Key files

- [`config/routes.rb`](../config/routes.rb) — the URL map; the entry point for every request.
- [`app/controllers/`](../app/controllers/) — controllers (request handlers).
- [`app/models/`](../app/models/) — domain models (ActiveRecord).
- [`app/views/`](../app/views/) — templates (ERB).
- [`config/`](../config/) — app, environment, and database configuration.
- [`db/`](../db/) — migrations, schema, and seeds.
- [`test/`](../test/) — the test suite.

## The mental model

A request flows **route → controller action → (model) → view**:

1. [`config/routes.rb`](../config/routes.rb) matches the URL to a `controller#action`.
2. The controller action runs, usually loading data via a **model**.
3. The action renders a **view** (HTML) back to the browser.

The health route is the one route present from the start:

```ruby
get "up" => "rails/health#show", as: :rails_health_check
```

## Verify

- `bin/rails server` boots without errors.
- `curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000/up` prints `200`.

## Next

→ [Milestone 1 — Scaffold a Post](01-scaffold-post.md)
