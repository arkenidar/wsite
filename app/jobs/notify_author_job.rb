class NotifyAuthorJob < ApplicationJob
  queue_as :default

  # `comment` arrives as a GlobalID reference and is rehydrated into the real
  # ActiveRecord object by the time perform runs.
  def perform(comment)
    Rails.logger.info(
      "[NotifyAuthorJob] New comment ##{comment.id} on Post ##{comment.post_id} " \
      "(#{comment.post.title.inspect}): #{comment.body.inspect}"
    )
    # In a real app you'd send an email here, e.g. PostMailer.new_comment(comment).deliver_now
  end
end
