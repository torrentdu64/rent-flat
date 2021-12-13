require "application_system_test_case"

class FlatsTest < ApplicationSystemTestCase
  test "flat index system" do
    visit "/flats"

    assert_selector "h1", text: "Flats#index"
  end

  test "flat name present" do
    visit flats_path

    assert_selector "a", text: "Ponsonby flat"
  end
end
