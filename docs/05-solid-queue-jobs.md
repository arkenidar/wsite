# Milestone 5 — Background Jobs with Solid Queue

**Goal:** run work asynchronously so web requests return immediately — using Rails 8's
DB-backed default, no Redis required.

## Concepts you'll learn

- **ActiveJob** — the stable abstraction your code talks to.
- **Solid Queue** — a DB-backed queue (replaces Sidekiq/Redis).
- **GlobalID** job arguments.
- `perform_later` vs `perform_now`; running the worker with `bin/jobs`.

## Steps

1. **Generate the job** and make it do something observable —
   [`app/jobs/notify_author_job.rb`](../app/jobs/notify_author_job.rb):

   ```bash
   bin/rails generate job NotifyAuthor
   ```

   ```ruby
   def perform(comment)
     Rails.logger.info "[NotifyAuthorJob] New comment ##{comment.id} on Post ##{comment.post_id}"
     # In a real app: PostMailer.new_comment(comment).deliver_now
   end
   ```

2. **Enqueue it** after a comment is saved —
   [`app/controllers/comments_controller.rb`](../app/controllers/comments_controller.rb):

   ```ruby
   NotifyAuthorJob.perform_later(@comment)
   ```

3. **Use Solid Queue in development** (it's already the production default). This app
   gives development its own queue database, mirroring production:

   - [`config/database.yml`](../config/database.yml) — adds a `queue` sub-database under
     `development` (`storage/development_queue.sqlite3`, `migrations_paths: db/queue_migrate`).
   - [`config/environments/development.rb`](../config/environments/development.rb):

     ```ruby
     config.active_job.queue_adapter = :solid_queue
     config.solid_queue.connects_to = { database: { writing: :queue } }
     ```

   - Create the queue DB from its schema ([`db/queue_schema.rb`](../db/queue_schema.rb)):

     ```bash
     bin/rails db:prepare
     ```

4. **Run the worker**:

   ```bash
   bin/jobs
   ```

## How the flow works

1. `perform_later` **serializes** the job into the `solid_queue_jobs` table. The comment
   is passed as a **GlobalID** (`gid://wsite/Comment/1`), rehydrated into the real record
   when the job runs — that's why jobs take small, serializable arguments.
2. `bin/jobs` polls the table, claims the job, runs `perform`, and deletes the row. You'll
   see in `log/development.log`:

   ```
   Performed NotifyAuthorJob (Job ID: …) from SolidQueue(default) in 52ms
   ```

## What changed vs. classic Rails

- Background jobs used to require running **Redis + Sidekiq** as separate infrastructure.
  Solid Queue is just **SQL tables** in a database — nothing extra to run or back up.
- In production this app can run the worker *inside* Puma via `SOLID_QUEUE_IN_PUMA: true`
  (see [`config/deploy.yml`](../config/deploy.yml)), so there's no separate worker process
  to deploy. Scheduled (cron-like) jobs live in [`config/recurring.yml`](../config/recurring.yml).

## Testing jobs

The **test** environment uses the `:test` adapter — jobs are recorded for assertions but
not actually run, keeping tests fast and deterministic. See
[`test/jobs/notify_author_job_test.rb`](../test/jobs/notify_author_job_test.rb):

```ruby
assert_enqueued_with(job: NotifyAuthorJob) { … }
perform_enqueued_jobs { NotifyAuthorJob.perform_later(comment) }
```

## Verify

```bash
# In one shell, start the worker:
bin/jobs
# In another, enqueue a job:
bin/rails runner 'NotifyAuthorJob.perform_later(Comment.first)'
# The worker shell logs the job running; then:
bin/rails test test/jobs/notify_author_job_test.rb
```

## Commit

`git show "M5: notify author via a Solid Queue background job"`

## Next

→ [Milestone 6 — Quality & deploy](06-quality-and-deploy.md)
