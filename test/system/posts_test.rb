require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Posts"
  end

  test "creating a Post through the browser" do
    visit posts_url
    click_on "New post"

    fill_in "Title", with: "Created by a system test"
    fill_in "Body", with: "This was typed into a real (headless) browser."
    check "Published"
    click_on "Create Post"

    assert_text "Post was successfully created"
    assert_text "Created by a system test"
  end

  test "showing validation errors for an invalid Post" do
    visit new_post_url
    click_on "Create Post"

    # title/body are blank, so the form re-renders with errors
    assert_text "can't be blank"
  end
end
