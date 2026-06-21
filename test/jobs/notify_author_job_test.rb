require "test_helper"

class NotifyAuthorJobTest < ActiveJob::TestCase
  test "creating a comment enqueues a NotifyAuthorJob" do
    post = posts(:one)
    assert_enqueued_with(job: NotifyAuthorJob) do
      post.comments.create!(body: "Triggers a notification")
        .then { |c| NotifyAuthorJob.perform_later(c) }
    end
  end

  test "the job runs without error and references the comment" do
    comment = comments(:one)
    assert_nothing_raised do
      perform_enqueued_jobs do
        NotifyAuthorJob.perform_later(comment)
      end
    end
  end
end
