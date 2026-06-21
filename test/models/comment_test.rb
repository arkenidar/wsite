require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "valid comment belongs to a post and has a body" do
    comment = posts(:one).comments.build(body: "Nice post!")
    assert comment.valid?
  end

  test "body is required" do
    comment = posts(:one).comments.build(body: nil)
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "post is required (belongs_to is mandatory by default)" do
    comment = Comment.new(body: "Orphan with no post")
    assert_not comment.valid?
    assert_includes comment.errors[:post], "must exist"
  end
end
