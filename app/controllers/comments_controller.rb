class CommentsController < ApplicationController
  before_action :set_post

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        # create.turbo_stream.erb appends the comment and resets the form
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment added." }
      else
        # Re-render the form (with errors) in place
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_comment",
            partial: "comments/form",
            locals: { post: @post, comment: @comment }
          )
        end
        format.html { redirect_to @post, alert: "Comment was invalid." }
      end
    end
  end

  # DELETE /posts/:post_id/comments/:id
  def destroy
    @comment = @post.comments.find(params.expect(:id))
    @comment.destroy

    respond_to do |format|
      format.turbo_stream # destroy.turbo_stream.erb removes the element
      format.html { redirect_to @post, notice: "Comment removed.", status: :see_other }
    end
  end

  private
    def set_post
      @post = Post.find(params.expect(:post_id))
    end

    def comment_params
      params.expect(comment: [ :body ])
    end
end
