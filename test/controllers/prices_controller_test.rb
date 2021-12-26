require "test_helper"

class PricesControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get prices_destroy_url
    assert_response :success
  end
end
