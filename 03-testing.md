# Milestone 3 — Testing

**Goal:** lock behavior in with the built-in test stack — the "test pyramid."

## Concepts you'll learn

- **Minitest** and **fixtures**.
- The three test layers: **model**, **integration**, and **system** (browser).
- Running tests: `bin/rails test`, `test:system`, `test:all`.

## The three layers

| Layer | Speed | Tests | File(s) |
|-------|-------|-------|---------|
| **Model** | fastest | validations, associations — no HTTP | [`test/models/post_test.rb`](https://github.com/arkenidar/wsite/blob/main/test/models/post_test.rb), [`test/models/comment_test.rb`](https://github.com/arkenidar/wsite/blob/main/test/models/comment_test.rb) |
| **Integration** | fast | full route → controller → view over HTTP, no browser | [`test/controllers/posts_controller_test.rb`](https://github.com/arkenidar/wsite/blob/main/test/controllers/posts_controller_test.rb) |
| **System** | slow | a real headless browser via Capybara | [`test/system/posts_test.rb`](https://github.com/arkenidar/wsite/blob/main/test/system/posts_test.rb) |

Write **many** model tests, **some** integration tests, **few** system tests.

## Steps

1. **Model tests** — assert validations and association behavior, e.g. that
   `dependent: :destroy` actually removes comments:

   ```ruby
   test "destroying a post destroys its comments" do
     post = posts(:one)
     assert_difference("Comment.count", -post.comments.count) { post.destroy }
   end
   ```

2. **Integration test** — cover the *unhappy path* the scaffold omits (blank fields
   create nothing and return 422):

   ```ruby
   test "should not create invalid post and re-render form" do
     assert_no_difference("Post.count") do
       post posts_url, params: { post: { title: "", body: "" } }
     end
     assert_response :unprocessable_content
   end
   ```

3. **System test** — drive a real browser. This requires the base class
   [`test/application_system_test_case.rb`](https://github.com/arkenidar/wsite/blob/main/test/application_system_test_case.rb):

   ```ruby
   driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
   ```

   ```ruby
   test "creating a Post through the browser" do
     visit posts_url
     click_on "New post"
     fill_in "Title", with: "Created by a system test"
     fill_in "Body", with: "Typed into a real browser."
     check "Published"
     click_on "Create Post"
     assert_text "Post was successfully created"
   end
   ```

## Fixtures

Fixtures are named sample records loaded into a dedicated **test database**, reset
between tests so each runs in isolation (inside a transaction that rolls back). Defined
in [`test/fixtures/posts.yml`](https://github.com/arkenidar/wsite/blob/main/test/fixtures/posts.yml) and referenced as `posts(:one)`.
Rails auto-populates `created_at`/`updated_at` for fixtures.

## Run the suite

```bash
bin/rails test          # model + integration
bin/rails test:system   # browser tests (needs Chromium)
bin/rails test:all      # everything
```

## Verify

```bash
bin/rails test:all      # => all runs, 0 failures, 0 errors
```

## Commit

`git show "M3: add model, integration, and system tests"`

## Next

→ [Milestone 4 — Hotwire](04-hotwire.md)
