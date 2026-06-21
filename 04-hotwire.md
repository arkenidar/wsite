# Milestone 4 — Hotwire (live comments)

**Goal:** make the UI dynamic — add comments that appear without a full page reload —
*without* writing a frontend framework or a JSON API. This is the biggest change since
"classic" Rails.

## Concepts you'll learn

- **Turbo Drive**, **Turbo Frames**, **Turbo Streams**.
- **Stimulus** controllers (the JS "sprinkle" pattern).
- **Importmap** — JavaScript with no Node, no build step.

## The three parts of Hotwire

- **Turbo Drive** (on by default, no code): intercepts link clicks and form submits,
  swaps the `<body>` via `fetch()` — navigation with no full reload.
- **Turbo Streams**: the server returns HTML fragments wrapped in
  `<turbo-stream action="append" target="comments">…</turbo-stream>` and Turbo applies
  them. Actions: `append, prepend, replace, update, remove, before, after`, targeted by DOM id.
- **Turbo Frames**: a `<turbo-frame>` scopes navigation to a region. Use a **Frame** to
  update one box (inline edit, tabs); use a **Stream** when one action touches several
  places (here: add to the list *and* reset the form).

## Steps

1. **Nest the routes** in [`config/routes.rb`](https://github.com/arkenidar/wsite/blob/main/config/routes.rb):

   ```ruby
   resources :posts do
     resources :comments, only: %i[ create destroy ]
   end
   ```

2. **Controller responds with `turbo_stream`** —
   [`app/controllers/comments_controller.rb`](https://github.com/arkenidar/wsite/blob/main/app/controllers/comments_controller.rb):

   ```ruby
   if @comment.save
     format.turbo_stream                 # renders create.turbo_stream.erb
     format.html { redirect_to @post }
   end
   ```

3. **Stream templates** describe the DOM changes:
   - [`app/views/comments/create.turbo_stream.erb`](https://github.com/arkenidar/wsite/blob/main/app/views/comments/create.turbo_stream.erb):

     ```erb
     <%= turbo_stream.append "comments", @comment %>
     <%= turbo_stream.replace "new_comment", partial: "comments/form",
           locals: { post: @post, comment: Comment.new } %>
     ```

   - [`app/views/comments/destroy.turbo_stream.erb`](https://github.com/arkenidar/wsite/blob/main/app/views/comments/destroy.turbo_stream.erb):

     ```erb
     <%= turbo_stream.remove @comment %>
     ```

4. **Views**: the comments list + form live on the post show page
   ([`app/views/posts/show.html.erb`](https://github.com/arkenidar/wsite/blob/main/app/views/posts/show.html.erb)) with a
   `<div id="comments">` target; the partials are
   [`app/views/comments/_comment.html.erb`](https://github.com/arkenidar/wsite/blob/main/app/views/comments/_comment.html.erb)
   (uses `dom_id` so streams can target it) and
   [`app/views/comments/_form.html.erb`](https://github.com/arkenidar/wsite/blob/main/app/views/comments/_form.html.erb).

5. **Stimulus sprinkle** — a live character counter,
   [`app/javascript/controllers/character_counter_controller.js`](https://github.com/arkenidar/wsite/blob/main/app/javascript/controllers/character_counter_controller.js),
   wired into the post body field in [`app/views/posts/_form.html.erb`](https://github.com/arkenidar/wsite/blob/main/app/views/posts/_form.html.erb)
   via data attributes:

   ```erb
   <div data-controller="character-counter">
     <%= form.textarea :body,
           data: { character_counter_target: "input",
                   action: "input->character-counter#update" } %>
     <small data-character-counter-target="output"></small>
   </div>
   ```

## What changed vs. classic Rails

- No **jQuery**, no **Webpacker/Node**. JavaScript is loaded through **importmap**
  ([`config/importmap.rb`](https://github.com/arkenidar/wsite/blob/main/config/importmap.rb)); Stimulus controllers auto-register
  by filename via [`app/javascript/controllers/index.js`](https://github.com/arkenidar/wsite/blob/main/app/javascript/controllers/index.js).
  No `node_modules`, no `npm run build`.
- The server keeps rendering **HTML**; Turbo applies it surgically. You stay in Ruby/ERB
  for ~90% of interactivity.

## Verify

- Browser: open a post, add a comment — it appears with **no full page reload**; delete
  one — it vanishes live; type in the New/Edit body field — the character counter updates.
- Tests: [`test/system/comments_test.rb`](https://github.com/arkenidar/wsite/blob/main/test/system/comments_test.rb) asserts the
  no-reload behavior (a JS marker survives the submit), the live delete, and the counter.

  ```bash
  bin/rails test test/system/comments_test.rb
  ```

## Commit

`git show "M4: live comments with Hotwire (Turbo Streams + Stimulus)"`

## Next

→ [Milestone 5 — Background jobs](05-solid-queue-jobs.md)
