# Milestone 1 — Scaffold a Post (CRUD)

**Goal:** generate a complete `Post` resource and understand every file it creates.

## Concepts you'll learn

- Rails **generators** and the **scaffold**.
- **Migrations** and the schema.
- RESTful **routes** (`resources :posts`).
- Controller actions, **strong parameters** (`params.expect`), and ERB views.
- **CSRF** protection.

## Steps

```bash
bin/rails generate scaffold Post title:string body:text published:boolean
bin/rails db:migrate
```

Then make the posts index the home page in [`config/routes.rb`](../config/routes.rb):

```ruby
root "posts#index"
```

`resources :posts` (added by the generator) produces the 7 RESTful routes:

```
GET    /posts            posts#index
POST   /posts            posts#create
GET    /posts/new        posts#new
GET    /posts/:id/edit   posts#edit
GET    /posts/:id        posts#show
PATCH  /posts/:id        posts#update
DELETE /posts/:id        posts#destroy
```

## Key files

- [`db/migrate/20260621212802_create_posts.rb`](../db/migrate/20260621212802_create_posts.rb) — creates the `posts` table; `change` is reversible, `t.timestamps` adds `created_at`/`updated_at`.
- [`db/schema.rb`](../db/schema.rb) — the authoritative snapshot of the DB structure (generated; never edit by hand).
- [`app/models/post.rb`](../app/models/post.rb) — the model; empty here because the DB defines the shape ("convention over configuration").
- [`app/controllers/posts_controller.rb`](../app/controllers/posts_controller.rb) — the 7 actions; serves both HTML and JSON.
- [`app/views/posts/`](../app/views/posts/) — `index/show/new/edit` pages, plus `_form` and `_post` **partials**, and `.jbuilder` JSON views.
- [`config/routes.rb`](../config/routes.rb) — `resources :posts` and `root`.

## What changed vs. classic Rails

- **Strong parameters** use the Rails 8 form: `params.expect(post: [ :title, :body, :published ])`
  (replaces `params.require(:post).permit(...)`; it also rejects malformed param structures).
- Validation failures render with `status: :unprocessable_content` (422); redirects after
  update/destroy use `status: :see_other` (303) — both matter for Hotwire (Milestone 4).

## CSRF lesson

Every form Rails renders includes an **authenticity token**. A write request without it
is rejected:

```
ActionController::InvalidAuthenticityToken (Can't verify CSRF token authenticity.)
```

That's why a browser form works but a raw `curl -X POST` does not — security by default.
To create records outside a browser, use the console instead:

```bash
bin/rails runner 'Post.create!(title: "Hello Rails 8", body: "My first post.", published: true)'
```

## Verify

- Open <http://localhost:3000/posts> and create / edit / delete a post in the browser.
- `bin/rails routes -c posts` lists the 7 routes plus `root`.

## Commit

`git show "M1: scaffold Post resource (CRUD) and set root route"`

## Next

→ [Milestone 2 — Validations & associations](02-validations-and-associations.md)
