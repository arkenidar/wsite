require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid post with title and body" do
    post = Post.new(title: "A good title", body: "Some body text")
    assert post.valid?
  end

  test "title is required" do
    post = Post.new(body: "Body but no title")
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "title must be at least 3 characters" do
    post = Post.new(title: "ab", body: "Body")
    assert_not post.valid?
    assert_includes post.errors[:title], "is too short (minimum is 3 characters)"
  end

  test "body is required" do
    post = Post.new(title: "Has a title")
    assert_not post.valid?
    assert_includes post.errors[:body], "can't be blank"
  end

  test "has many comments" do
    post = posts(:one)
    assert_respond_to post, :comments
    assert_includes post.comments, comments(:one)
  end

  test "destroying a post destroys its comments" do
    post = posts(:one)
    assert post.comments.any?, "fixture should give post :one at least one comment"
    assert_difference("Comment.count", -post.comments.count) do
      post.destroy
    end
  end
end
