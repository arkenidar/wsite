# Milestone 2 — Validations & Associations

**Goal:** add data rules to `Post` and introduce a related `Comment` model.

## Concepts you'll learn

- ActiveRecord **validations**.
- **Associations**: `has_many` / `belongs_to`.
- Why `belongs_to` is **required by default**.
- The Rails **console** and the **query interface**.

## Steps

Add validations and the association to [`app/models/post.rb`](https://github.com/arkenidar/wsite/blob/main/app/models/post.rb):

```ruby
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 120 }
  validates :body, presence: true
end
```

Generate the `Comment` model (a reference to `Post`) and migrate:

```bash
bin/rails generate model Comment post:references body:text
bin/rails db:migrate
```

Add a validation to [`app/models/comment.rb`](https://github.com/arkenidar/wsite/blob/main/app/models/comment.rb) (the generator
already added `belongs_to :post`):

```ruby
validates :body, presence: true
```

## Key files

- [`app/models/post.rb`](https://github.com/arkenidar/wsite/blob/main/app/models/post.rb) — validations + `has_many :comments, dependent: :destroy`.
- [`app/models/comment.rb`](https://github.com/arkenidar/wsite/blob/main/app/models/comment.rb) — `belongs_to :post` + body validation.
- [`db/migrate/20260621213241_create_comments.rb`](https://github.com/arkenidar/wsite/blob/main/db/migrate/20260621213241_create_comments.rb) — `comments` table with `t.references :post, null: false, foreign_key: true`.

## Explore in the console

```bash
bin/rails console
```

```ruby
# 1. Validation rejects a bad Post
Post.new.valid?                      # => false
Post.new.tap(&:valid?).errors.full_messages
# => ["Title can't be blank", "Title is too short (minimum is 3 characters)", "Body can't be blank"]

# 2. Associations both directions
post = Post.first
post.comments.create!(body: "First comment")
post.comments.count                  # => 1
Comment.last.post.title              # follow belongs_to back to the Post

# 3. belongs_to is required by default
Comment.new(body: "orphan").valid?   # => false  ("Post must exist")

# 4. Query interface (lazy — SQL runs when you need the data)
Post.where(published: true).count
Comment.order(created_at: :desc).first
```

## Key ideas

- **Validations** run automatically on `save`/`create!`/`update`, no matter how the
  record is created (form, console, API, job). They're your single source of truth for
  data integrity, and they power the red error messages in the scaffold's `_form`.
- `dependent: :destroy` means deleting a post deletes its comments (no orphans).
- The required `belongs_to` is enforced at **two layers**: the app (validation
  `"Post must exist"`) and the DB (`null: false, foreign_key: true`).
- Keep rules in the **model** ("fat model, skinny controller").

## Verify

- In the browser, submitting the New Post form with a blank title/body shows inline errors.
- In the console, the four snippets above behave as commented.

## Commit

`git show "M2: add Post validations, Comment model, and associations"`

## Next

→ [Milestone 3 — Testing](03-testing.md)
