require "application_system_test_case"

class HomePageTest < ApplicationSystemTestCase
  test "visit home" do
    visit root_path

    assert_selector "h1", text: "Pages#home"
  end

  test "link listing present" do
    visit root_path

    assert_selector "a", text: "Listing"
  end
end
