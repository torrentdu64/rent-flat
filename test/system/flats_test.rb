require "application_system_test_case"

class FlatsTest < ApplicationSystemTestCase
  test "flat index system" do
    visit "/flats"

    assert_selector "h1", text: "Flats#index"
  end

  # test "link listing present" do
  #   visit root_path

  #   assert_selector "a", text: "Listing"
  # end
end
