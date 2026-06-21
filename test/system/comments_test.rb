require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
  end

  test "adding a comment updates the list without a full page reload (Turbo Stream)" do
    visit post_url(@post)

    # Mark the current page so we can detect a full reload (which would wipe it).
    page.execute_script("document.body.dataset.noReload = 'true'")

    within "#new_comment" do
      fill_in "Add a comment", with: "Live comment via Turbo!"
      click_on "Post comment"
    end

    # The new comment shows up...
    assert_selector "#comments", text: "Live comment via Turbo!"
    # ...and the page was NOT fully reloaded (our marker survives).
    assert_equal "true", page.evaluate_script("document.body.dataset.noReload")
  end

  test "deleting a comment removes it live" do
    visit post_url(@post)
    assert_selector "#comments .comment"

    accept_confirm do
      within "#comments .comment", match: :first do
        click_on "Delete"
      end
    end

    assert_no_selector "#comments", text: comments(:one).body
  end

  test "Stimulus character counter updates as you type" do
    visit new_post_url
    fill_in "Body", with: "hello"
    assert_text "5 characters"
  end
end
