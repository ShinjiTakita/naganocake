require "test_helper"

class CustmoersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get custmoers_show_url
    assert_response :success
  end

  test "should get edit" do
    get custmoers_edit_url
    assert_response :success
  end

  test "should get unsubscribe" do
    get custmoers_unsubscribe_url
    assert_response :success
  end
end
